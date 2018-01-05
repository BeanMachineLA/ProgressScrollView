import UIKit

public class ScrollingBehaviour : NSObject, UIScrollViewDelegate
{
    public weak var flexibleHeightBar: FlexibleHeightBar!
    
    public var isElasticMaximumHeightAtTop: Bool = false
    
    public var isSnappingEnabled: Bool = true
    
    public var isCurrentlySnapping: Bool = false
 
    private var snappingPositionsForProgressRanges = [CGFloat : NSRange]()
    
    
    public func addSnappingPositionForProgress(progress: CGFloat, startProgress:CGFloat, endProgress:CGFloat)
    {
        let startProgressPercent = Int( fmax(fmin(startProgress, 1.0), 0.0) * 100 )
        let endProgressPercent = Int( fmax(fmin(endProgress, 1.0), 0.0) * 100 )
        
        let progressPercentRange = NSMakeRange(startProgressPercent, endProgressPercent - startProgressPercent)
        for (_, range) in snappingPositionsForProgressRanges
        {
            if NSIntersectionRange(progressPercentRange, range).length != 0
            { return } 
        }
        snappingPositionsForProgressRanges[progress] = progressPercentRange
    }
    
    
    public func removeSnappingPositionForProgress(progress: CGFloat)
    {
        snappingPositionsForProgressRanges.removeValueForKey(progress)
    }
    
    public func snapToProgress(progress:CGFloat, scrollView:UIScrollView)
    {
        let deltaProgress = progress - flexibleHeightBar.progress
        let deltaYOffset = (flexibleHeightBar.maximumBarHeight - flexibleHeightBar.minimumBarHeight) * deltaProgress
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y+deltaYOffset)
        
        flexibleHeightBar.progress = progress
        flexibleHeightBar.setNeedsLayout()
        flexibleHeightBar.layoutIfNeeded()
        
        isCurrentlySnapping = false
    }
    
    public func snapWithScrollView(scrollView: UIScrollView)
    {
        if !isCurrentlySnapping && isSnappingEnabled && flexibleHeightBar.progress >= 0.0
        {
            isCurrentlySnapping = true
            var snappingProgress = CGFloat.max
            let progressPercent = Int( flexibleHeightBar.progress * 100 )
            
            for (progress, range) in snappingPositionsForProgressRanges
            {
                if progressPercent >= range.location && progressPercent <= (range.location + range.length)
                {
                    snappingProgress = progress
                }
            }
            
            if snappingProgress != CGFloat.max
            {
                UIView.animateWithDuration(0.15, animations:
                {
                    () -> Void in
                    self.snapToProgress(snappingProgress, scrollView: scrollView)
                }, completion:
                {
                    (finished) -> Void in
                    self.isCurrentlySnapping = false
                })
            }
            else
            {
                isCurrentlySnapping = false
            }
        }
    }
    
    //MARK: ui scroll view delegate 
    public func scrollViewDidScroll(scrollView: UIScrollView)
    {
        scrollView.scrollIndicatorInsets.top =  CGRectGetHeight(flexibleHeightBar.bounds)
    }
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if (!decelerate) { snapWithScrollView(scrollView) }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        snapWithScrollView(scrollView)
    }
}
