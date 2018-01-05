import UIKit

public class ThresholdScrollingBehaviour : ScrollingBehaviour
{
    public var thresholdFromTop : CGFloat = 0.0 { didSet { thresholdFromTop = max(thresholdFromTop, 0.0) } }
    public var thresholdNegativeDirection : CGFloat = 0.0 { didSet { thresholdNegativeDirection = max(thresholdNegativeDirection, 0.0) } }
    public var thresholdPositiveDirection : CGFloat = 0.0 { didSet { thresholdPositiveDirection = max(thresholdPositiveDirection, 0.0) } }
    
    private var previousYOffset : CGFloat = 0.0
    private var previousProgress : CGFloat = 0.0
    
    public func applyFromTopProgressTrackingThreshold()
    {
        previousYOffset += thresholdFromTop
    }
    
    public func applyNegativeDirectionProgressTrackingThreshold()
    {
        if flexibleHeightBar.progress == 1.0
        {
            previousYOffset -= thresholdNegativeDirection
        }
    }
    
    public func applyPositiveDirectionProgressTrackingThreshold()
    {
        if flexibleHeightBar.progress == 0.0
        {
            previousYOffset += thresholdPositiveDirection;
        }
    }
    
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView)
    {
        let scrollViewViewportHeight = CGRectGetMaxY(scrollView.bounds) - CGRectGetMinY(scrollView.bounds)
        if (scrollView.contentOffset.y + scrollView.contentInset.top) >= 0.0 && scrollView.contentOffset.y <= (scrollView.contentSize.height - scrollViewViewportHeight)
        {
            previousYOffset = scrollView.contentOffset.y;
            previousProgress = flexibleHeightBar.progress;
            
            // Apply top threshold
            if (scrollView.contentOffset.y+scrollView.contentInset.top) == 0.0
            {
                self.applyFromTopProgressTrackingThreshold()
            }
            else
            {
                // Edge case (not true) - user is scrolling to the top but there isn't enough runway left to pass the threshold
                let barDelataHeight = flexibleHeightBar.maximumBarHeight - flexibleHeightBar.minimumBarHeight
                if (scrollView.contentOffset.y + scrollView.contentInset.top) > (thresholdNegativeDirection + barDelataHeight)
                {
                    self.applyNegativeDirectionProgressTrackingThreshold()
                }
                
                // Edge case (not true) - user is scrolling to the bottom but there isn't enough runway left to pass the threshold
                if(scrollView.contentOffset.y < (scrollView.contentSize.height - scrollViewViewportHeight - thresholdPositiveDirection))
                {
                    self.applyPositiveDirectionProgressTrackingThreshold()
                }
            }
        }
        //Edge case - user starts to scroll while the scroll view is stretched above the top
        else if (scrollView.contentOffset.y + scrollView.contentInset.top) < 0.0
        {
            previousYOffset = -scrollView.contentInset.top;
            previousProgress = 0.0;
            
            if thresholdFromTop != 0.0
            {
                self.applyFromTopProgressTrackingThreshold()
            }
            else
            {
                self.applyNegativeDirectionProgressTrackingThreshold()
                self.applyPositiveDirectionProgressTrackingThreshold()
            }
        }
        //Edge case - user starts to scroll while the scroll view is stretched below the bottom
        else if scrollView.contentOffset.y > (scrollView.contentSize.height-scrollViewViewportHeight)
        {
            if scrollView.contentSize.height > scrollViewViewportHeight
            {
                self.previousYOffset = scrollView.contentSize.height - scrollViewViewportHeight;
                self.previousProgress = 1.0;
                
                self.applyNegativeDirectionProgressTrackingThreshold()
                self.applyPositiveDirectionProgressTrackingThreshold()
            }
        }
    }
    
    public override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        super.scrollViewDidScroll(scrollView)
        
        if !isCurrentlySnapping
        {
            let deltaYOffset: CGFloat = scrollView.contentOffset.y - previousYOffset;
            let deltaProgress: CGFloat = deltaYOffset / (flexibleHeightBar.maximumBarHeight - flexibleHeightBar.minimumBarHeight);
            
            flexibleHeightBar.progress = previousProgress + deltaProgress;
            flexibleHeightBar.setNeedsLayout()
        }
    }
}
