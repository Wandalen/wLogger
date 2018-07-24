
let _ = require( '../include/dwtools/Base.s' );

_.include( 'wLogger' );

let hooked = '';
let l1 = new _.Logger({ name : 'l1', onTransformEnd : onTransformEnd });
let l2 = new _.Logger({ name : 'l2', onTransformEnd : onTransformEnd });

debugger;
l1.inputFrom( console );
debugger;
l2.inputFrom( l1 );

console.log( 'It is going to throw excpetion right now!' );

debugger;
l2.outputTo( console );
debugger;

function onTransformEnd( o )
{
  o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
  hooked += o.input[ 0 ] + '\n';
  return o;
}
