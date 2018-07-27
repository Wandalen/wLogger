
if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

let hooked = '';

let l1 = new _.Logger({ name : 'l1', onTransformEnd : onTransformEnd });

console.log( 'After inputFrom console with exclusiveOutput:1 will print nothing because l2 will steel all input of console' );

l1.inputFrom( console, { exclusiveOutput : 1 } );

console.log( 'This message will not get on screen' );

console.log( 'Lets unchain console' );

l1.inputUnchain( console );

console.log( 'l1 was unchained and console works as usually' );
console.log( 'When console was silent it was attempt to print' );
console.log( '```\n' + hooked + '```' );

function onTransformEnd( o )
{
  o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
  hooked += o.input[ 0 ] + '\n';
  return o;
}
