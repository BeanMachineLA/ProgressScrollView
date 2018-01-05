import UIKit

public class FlexibleHeightBar: UIView
{
    public var onProgressWillChange: ((oldProgress: CGFloat, newProgress: CGFloat)->Void)?
    public var onProgressChanged: ((progress: CGFloat)->Void)?
    public var progressDistance : CGFloat { get { return maximumBarHeight - minimumBarHeight } }
    
    public var progress: CGFloat = 0.0
    {
        willSet
        {
            var newProgress = min(newValue, 1.0)
            let elasticMaximumHeightOnTop = scrollingBehaviour?.isElasticMaximumHeightAtTop ?? false
            if !elasticMaximumHeightOnTop { newProgress = max(newProgress, 0.0) }
            if (newProgress != progress)
            { onProgressWillChange?(oldProgress: progress, newProgress: newProgress) }
        }
        didSet
        {
            progress = min(progress, 1.0)
            let elasticMaximumHeightOnTop = scrollingBehaviour?.isElasticMaximumHeightAtTop ?? false
            if !elasticMaximumHeightOnTop { progress = max(progress, 0.0) }
            onProgressChanged?(progress: progress)
        }
    }
    
    public var maximumBarHeight: CGFloat = 44.0 { didSet { maximumBarHeight = max(maximumBarHeight, 0.0) } }
    public var minimumBarHeight: CGFloat = 20.0 { didSet { minimumBarHeight = max(minimumBarHeight, 0.0) } }
    public var scrollingBehaviour: ScrollingBehaviour? { didSet { scrollingBehaviour?.flexibleHeightBar = self } }
    
    
    public required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        maximumBarHeight = CGRectGetMaxY(frame)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        maximumBarHeight = CGRectGetMaxY(self.bounds)
    }
    
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.frame.size.height = interpolateFromValue(maximumBarHeight, toValue: minimumBarHeight, progress: progress)
        
        let elasticMaximumHeightOnTop = scrollingBehaviour?.isElasticMaximumHeightAtTop ?? false
        if(elasticMaximumHeightOnTop) { progress = max(progress, 0.0) }
        
        for (inxex, view) in enumerate(self.subviews as! [UIView])
        {
            let layoutAttributesCount = view.numberOfLayoutAttributes()
            for var i: Int = 0; i < layoutAttributesCount; i++
            {
                let floorProgressPosition = view.progressAtIndex(i)
                if i+1 < layoutAttributesCount
                {
                    let ceilingProgressPosition = view.progressAtIndex(i+1)
                    if progress >= floorProgressPosition && progress < ceilingProgressPosition
                    {
                        let floorLayoutAttributes: FlexibleHeightBarLayoutAttributes = view.layoutAttributesAtIndex(i)
                        let ceilingLayoutAttributes: FlexibleHeightBarLayoutAttributes = view.layoutAttributesAtIndex(i+1)
                        self.applyFloorLayoutAttributes(floorLayoutAttributes, ceilingLayoutAttributes: ceilingLayoutAttributes, subview:view, floorProgress: floorProgressPosition, ceilingProgress: ceilingProgressPosition)
                    }

                }
                else
                {
                    if progress >= floorProgressPosition
                    {
                        let floorLayoutAttributes = view.layoutAttributesAtIndex(i)
                        self.applyFloorLayoutAttributes(floorLayoutAttributes, ceilingLayoutAttributes: floorLayoutAttributes, subview:view, floorProgress: floorProgressPosition, ceilingProgress: 1.0)
                    }
                }
            }
        }
    }
    
    
    private func applyFloorLayoutAttributes(floorLayoutAttributes: FlexibleHeightBarLayoutAttributes, ceilingLayoutAttributes:FlexibleHeightBarLayoutAttributes, subview:UIView, floorProgress:CGFloat, ceilingProgress:CGFloat)
    {
        let numerator = progress - floorProgress
        let denominator : CGFloat
        if ceilingProgress == floorProgress { denominator = ceilingProgress }
        else { denominator = ceilingProgress - floorProgress }
        let relativeProgress = numerator/denominator
        
        
        //interpolate transform
        var transform3D = CATransform3DIdentity
        transform3D.m11 = interpolateFromValue(floorLayoutAttributes.transform3D.m11, toValue: ceilingLayoutAttributes.transform3D.m11, progress: relativeProgress)
        transform3D.m12 = interpolateFromValue(floorLayoutAttributes.transform3D.m12, toValue: ceilingLayoutAttributes.transform3D.m12, progress: relativeProgress)
        transform3D.m13 = interpolateFromValue(floorLayoutAttributes.transform3D.m13, toValue: ceilingLayoutAttributes.transform3D.m13, progress: relativeProgress)
        transform3D.m14 = interpolateFromValue(floorLayoutAttributes.transform3D.m14, toValue: ceilingLayoutAttributes.transform3D.m14, progress: relativeProgress)
        
        transform3D.m21 = interpolateFromValue(floorLayoutAttributes.transform3D.m21, toValue: ceilingLayoutAttributes.transform3D.m21, progress: relativeProgress)
        transform3D.m22 = interpolateFromValue(floorLayoutAttributes.transform3D.m22, toValue: ceilingLayoutAttributes.transform3D.m22, progress: relativeProgress)
        transform3D.m23 = interpolateFromValue(floorLayoutAttributes.transform3D.m23, toValue: ceilingLayoutAttributes.transform3D.m23, progress: relativeProgress)
        transform3D.m24 = interpolateFromValue(floorLayoutAttributes.transform3D.m24, toValue: ceilingLayoutAttributes.transform3D.m24, progress: relativeProgress)
        
        transform3D.m31 = interpolateFromValue(floorLayoutAttributes.transform3D.m31, toValue: ceilingLayoutAttributes.transform3D.m31, progress: relativeProgress)
        transform3D.m32 = interpolateFromValue(floorLayoutAttributes.transform3D.m32, toValue: ceilingLayoutAttributes.transform3D.m32, progress: relativeProgress)
        transform3D.m33 = interpolateFromValue(floorLayoutAttributes.transform3D.m33, toValue: ceilingLayoutAttributes.transform3D.m33, progress: relativeProgress)
        transform3D.m34 = interpolateFromValue(floorLayoutAttributes.transform3D.m34, toValue: ceilingLayoutAttributes.transform3D.m34, progress: relativeProgress)
        
        transform3D.m41 = interpolateFromValue(floorLayoutAttributes.transform3D.m41, toValue: ceilingLayoutAttributes.transform3D.m41, progress: relativeProgress)
        transform3D.m42 = interpolateFromValue(floorLayoutAttributes.transform3D.m42, toValue: ceilingLayoutAttributes.transform3D.m42, progress: relativeProgress)
        transform3D.m43 = interpolateFromValue(floorLayoutAttributes.transform3D.m43, toValue: ceilingLayoutAttributes.transform3D.m43, progress: relativeProgress)
        transform3D.m44 = interpolateFromValue(floorLayoutAttributes.transform3D.m44, toValue: ceilingLayoutAttributes.transform3D.m44, progress: relativeProgress)
        
        
        //interpolate frame 
        let frame : CGRect
        if !CGRectEqualToRect(floorLayoutAttributes.frame, CGRectNull) && CGRectEqualToRect(ceilingLayoutAttributes.frame, CGRectNull)
        {
            frame = floorLayoutAttributes.frame
        }
        else if CGRectEqualToRect(floorLayoutAttributes.frame, CGRectNull) && CGRectEqualToRect(ceilingLayoutAttributes.frame, CGRectNull)
        {
            frame = subview.frame
        }
        else
        {
            let x = interpolateFromValue(CGRectGetMinX(floorLayoutAttributes.frame), toValue:CGRectGetMinX(ceilingLayoutAttributes.frame), progress:relativeProgress)
            let y = interpolateFromValue(CGRectGetMinY(floorLayoutAttributes.frame), toValue:CGRectGetMinY(ceilingLayoutAttributes.frame), progress:relativeProgress)
            let width = interpolateFromValue(CGRectGetWidth(floorLayoutAttributes.frame), toValue:CGRectGetWidth(ceilingLayoutAttributes.frame), progress:relativeProgress)
            let height = interpolateFromValue(CGRectGetHeight(floorLayoutAttributes.frame), toValue:CGRectGetHeight(ceilingLayoutAttributes.frame), progress:relativeProgress)
            frame = CGRectMake(x, y, width, height)
        }
        
        
        //interpolate center 
        let centerX = interpolateFromValue(floorLayoutAttributes.center.x, toValue:ceilingLayoutAttributes.center.x, progress:relativeProgress)
        let centerY = interpolateFromValue(floorLayoutAttributes.center.y, toValue:ceilingLayoutAttributes.center.y, progress:relativeProgress)
        let center = CGPointMake(centerX, centerY)
        
        
        //interpolate bounds
        let x = interpolateFromValue(CGRectGetMinX(floorLayoutAttributes.bounds), toValue:CGRectGetMinX(ceilingLayoutAttributes.bounds), progress:relativeProgress)
        let y = interpolateFromValue(CGRectGetMinY(floorLayoutAttributes.bounds), toValue:CGRectGetMinY(ceilingLayoutAttributes.bounds), progress:relativeProgress)
        let width = interpolateFromValue(CGRectGetWidth(floorLayoutAttributes.bounds), toValue:CGRectGetWidth(ceilingLayoutAttributes.bounds), progress:relativeProgress)
        let height = interpolateFromValue(CGRectGetHeight(floorLayoutAttributes.bounds), toValue:CGRectGetHeight(ceilingLayoutAttributes.bounds), progress:relativeProgress)
        let bounds = CGRectMake(x, y, width, height)
        
        
        //interpolate alpha
        let alpha = interpolateFromValue(floorLayoutAttributes.alpha, toValue:ceilingLayoutAttributes.alpha, progress:relativeProgress)
        
        
        //apply interpolated values
        subview.layer.transform = transform3D
        if CATransform3DIsIdentity(transform3D) { subview.frame = frame }
        subview.center = center
        subview.bounds = bounds
        subview.alpha = alpha
        subview.layer.zPosition = floorLayoutAttributes.zIndex
        subview.hidden = floorLayoutAttributes.hidden
    }
    
    //utilities
    private func interpolateFromValue(fromValue: CGFloat, toValue: CGFloat, progress:CGFloat) -> CGFloat
    {
        return fromValue - ((fromValue-toValue) * progress);
    }
    
}
