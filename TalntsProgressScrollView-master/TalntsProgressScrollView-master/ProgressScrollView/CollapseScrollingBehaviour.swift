import UIKit

public class CollapseScrollingBehaviour : ScrollingBehaviour
{
    public override func scrollViewDidScroll(scrollView: UIScrollView)
    {
        super.scrollViewDidScroll(scrollView)
        
        if !isCurrentlySnapping
        {
            let progress = (scrollView.contentOffset.y + scrollView.contentInset.top) / (flexibleHeightBar.maximumBarHeight - flexibleHeightBar.minimumBarHeight)
            flexibleHeightBar.progress = progress
            flexibleHeightBar.setNeedsLayout()
        }
    }
}
