
if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

let l1 = new _.Logger({ name : 'l1', onTransformBegin });
let l2 = new _.Logger({ name : 'l2', onTransformBegin });
let l3 = new _.Logger({ name : 'l3', onTransformBegin });

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
  o.input[ 0 ] = o.input[ 0 ] + ' : ' + this.name;
  return o;
}
