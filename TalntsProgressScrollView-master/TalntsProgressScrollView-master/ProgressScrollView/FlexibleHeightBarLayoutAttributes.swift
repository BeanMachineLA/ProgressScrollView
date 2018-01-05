import UIKit

public class FlexibleHeightBarLayoutAttributes
{
    public var frame : CGRect
    {
        get { return _frame }
        set
        {
            if CGAffineTransformIsIdentity(transform) && CATransform3DIsIdentity(transform3D) { _frame = newValue }
            _center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
            _size = CGSizeMake(CGRectGetWidth(_frame), CGRectGetHeight(_frame));
            _bounds = CGRectMake(CGRectGetMinX(_bounds), CGRectGetMinY(_bounds), _size.width, _size.height);
        }
    }
    
    public var bounds : CGRect
    {
        get { return _bounds }
        set
        {
            if newValue.origin.x != 0.0 || newValue.origin.y != 0.0 { return }
            _bounds = newValue
            _size = CGSizeMake(CGRectGetWidth(_bounds), CGRectGetHeight(_bounds))
        }
    }
    
    public var center : CGPoint
    {
        get { return _center }
        set
        {
            _center = newValue;
            if CGAffineTransformIsIdentity(_transform) && CATransform3DIsIdentity(_transform3D)
            {
                _frame = CGRectMake(newValue.x - CGRectGetMidX(_bounds), newValue.y - CGRectGetMidY(_bounds), CGRectGetWidth(_frame), CGRectGetHeight(_frame))
            }
        }
    }
    
    public var size : CGSize
    {
        get { return _size }
        set
        {
            _size = newValue;
            if CGAffineTransformIsIdentity(_transform) && CATransform3DIsIdentity(_transform3D)
            {
                _frame = CGRectMake(CGRectGetMinX(_frame), CGRectGetMinY(_frame), newValue.width, newValue.height)
            }
            _bounds = CGRectMake(CGRectGetMinX(_bounds), CGRectGetMinY(_bounds), newValue.width, newValue.height)
        }
    }
    
    public var transform3D : CATransform3D
    {
        get { return _transform3D }
        set
        {
            _transform3D = newValue
            _transform = CGAffineTransformMake(newValue.m11, newValue.m12, newValue.m21, newValue.m22, newValue.m41, newValue.m42)
            if(!CATransform3DIsIdentity(transform3D)) { _frame = CGRectNull }
        }
    }
    
    public var transform : CGAffineTransform
    {
        get { return _transform }
        set
        {
            _transform = newValue
            _transform3D = CATransform3DMakeAffineTransform(newValue);
            if(!CGAffineTransformIsIdentity(transform)) { _frame = CGRectNull }
        }
    }

    public var alpha : CGFloat
    public var zIndex : CGFloat
    public var hidden : Bool
    
    //private variables
    private var _frame : CGRect
    private var _bounds : CGRect
    private var _center : CGPoint
    private var _size : CGSize
    private var _transform3D : CATransform3D
    private var _transform : CGAffineTransform
    
    public init()
    {
        _frame = CGRectZero
        _bounds = CGRectZero
        _center = CGPointZero
        _size = CGSizeZero
        _transform3D = CATransform3DIdentity
        _transform = CGAffineTransformIdentity
        alpha = 1.0
        zIndex = 0
        hidden = false
    }
    
    public init(view: UIView)
    {
        _frame = view.frame
        _bounds = view.bounds
        _center = view.center
        _size = view.frame.size
        _transform3D = view.layer.transform
        _transform = view.transform
        alpha = view.alpha
        zIndex = view.layer.zPosition
        hidden = view.hidden
    }
    
    public init(attributes: FlexibleHeightBarLayoutAttributes)
    {
        _frame = attributes.frame
        _bounds = attributes.bounds
        _center = attributes.center
        _size = attributes.size
        _transform3D = attributes.transform3D
        _transform = attributes.transform
        alpha = attributes.alpha
        zIndex = attributes.zIndex
        hidden = attributes.hidden
    }
}
