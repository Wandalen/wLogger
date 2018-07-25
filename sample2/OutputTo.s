
let _ = require( '../include/dwtools/Base.s' );

_.include( 'wLogger' );

let l1 = new _.Logger({ name : 'l1', onTransformBegin : onTransformBegin });
let l2 = new _.Logger({ name : 'l2', onTransformBegin : onTransformBegin });
let l3 = new _.Logger({ name : 'l3', onTransformBegin : onTransformBegin });

l1.outputTo( l2 );
l2.outputTo( l3 );
l3.outputTo( console );

l1.log( 'hello' );

l2.outputUnchain( l3 );
l2.outputTo( console );

l1.log( 'hello2' );

l2.outputUnchain( console );
l3.outputUnchain( console );

l1.log( 'hello3' );

function onTransformBegin( o )
{
  o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
  return o;
}
