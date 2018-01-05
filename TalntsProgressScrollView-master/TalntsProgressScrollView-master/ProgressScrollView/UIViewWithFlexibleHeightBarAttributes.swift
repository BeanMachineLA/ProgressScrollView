import UIKit
import ObjectiveC

private var kProgressArrayAssociationKey: UInt8 = 0
private var kAttributesArrayAssociationKey: UInt8 = 0
public extension UIView
{
    public func addLayoutAttributes(attribute: FlexibleHeightBarLayoutAttributes, var forProgress progress:CGFloat)
    {
        progress = max(min(progress, 1.0), 0.0)
        for (index, p) in enumerate(progressValues)
        {
            if progress == p
            {
                layoutAttributesForProgressValues[index] = attribute
                return
            }
        }
        var indexToInsert: Int = 0
        for (index, existingProgress) in enumerate(progressValues)
        {
            if progress > existingProgress
            {
                indexToInsert++
            }
            else { break }
        }
        
        progressValues.insert(progress, atIndex: indexToInsert)
        layoutAttributesForProgressValues.insert(attribute, atIndex: indexToInsert)
    }
    
    public func removeLayoutAttributeForProgress(progress: CGFloat)
    {
        let index = find(progressValues, progress)
        if let i = index
        {
            progressValues.removeAtIndex(i)
            layoutAttributesForProgressValues.removeAtIndex(i)
        }
    }
    
    public func numberOfLayoutAttributes() -> Int
    {
        return layoutAttributesForProgressValues.count
    }
    
    public func progressAtIndex(index: Int) -> CGFloat
    {
        let progress = progressValues[index]
        return progress
    }
    
    public func layoutAttributesAtIndex(index: Int) -> FlexibleHeightBarLayoutAttributes
    {
        let attribute = layoutAttributesForProgressValues[index]
        return attribute
    }
    
    public func layoutAttributesAtProgress(progress: CGFloat) -> FlexibleHeightBarLayoutAttributes?
    {
        let index = find(progressValues, progress)
        if let i = index { return layoutAttributesAtIndex(i) }
        return nil
    }
    
    //MARK: private stored properties
    private var layoutAttributesForProgressValues: [FlexibleHeightBarLayoutAttributes]
    {
        get
        {
            var array = objc_getAssociatedObject(self, &kAttributesArrayAssociationKey) as? [FlexibleHeightBarLayoutAttributes]
            if array == nil
            {
                array = [FlexibleHeightBarLayoutAttributes]()
                objc_setAssociatedObject(self, &kAttributesArrayAssociationKey, array, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            }
            return array!
        }
        set { objc_setAssociatedObject(self, &kAttributesArrayAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN)) }
    }
    
    private var progressValues: [CGFloat]
    {
        get
        {
            var array = objc_getAssociatedObject(self, &kProgressArrayAssociationKey) as? [CGFloat]
            if array == nil
            {
                array = [CGFloat]()
                objc_setAssociatedObject(self, &kProgressArrayAssociationKey, array, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            }
            return array!
        }
        set { objc_setAssociatedObject(self, &kProgressArrayAssociationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN)) }
    }
}
