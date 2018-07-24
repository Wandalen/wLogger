
let _ = require( '../include/dwtools/Base.s' );

_.include( 'wLogger' );

let hooked = '';

let l1 = new _.Logger({ name : 'l1', onTransformEnd : onTransformEnd });
let l2 = new _.Logger({ name : 'l2', onTransformEnd : onTransformEnd });

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

function onTransformEnd( o )
{
  o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
  hooked += o.input[ 0 ] + '\n';
  return o;
}
