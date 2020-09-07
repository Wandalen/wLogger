
if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

let hooked = '';

let l1 = new _.Logger({ name : 'l1', onTransformBegin });
let l2 = new _.Logger({ name : 'l2', onTransformBegin });

l1.inputFrom( console );

console.log( 'hello' );
console.log( hooked );
hooked = '';

l2.inputFrom( console );

console.log( 'hello2' );
console.log( hooked );
hooked = '';

l2.inputUnchain( console );

console.log( 'hello3' );
console.log( hooked );
hooked = '';

function onTransformBegin( o )
{
  hooked += this.name + ' : ' + o.input[ 0 ] + '\n';
  return o;
}
