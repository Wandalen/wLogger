
/* qqq : pay attention on difference between ExclusiveOutputFromConsole and ExclusiveOutputFromLogger */

if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

let hooked = '';

let l1 = new _.Logger({ name : 'l1', onTransformBegin });
let l2 = new _.Logger({ name : 'l2', onTransformBegin });

l1.outputTo( console );

l1.log( 'hello' );

console.log( 'After inputFrom l1 with exclusiveOutput:1 will print nothing because l2 will steel all input of l1' );

hooked = '';
l1.outputTo( l2, { exclusiveOutput : 1 } );

l1.log( 'This message will not get on screen' );

console.log();
console.log( 'As you may ( not ) see - nothing' );

console.log( 'When l1 was silent it was attempt to print' );
console.log( '```\n' + hooked + '```' );

console.log( 'Lets now output l2 to console' );

l2.outputTo( console );

l1.log( 'This message will get on screen with chain l1 -> l2 -> console' );

console.log( 'As you may see onTransformBegin was not even launched for l1' );

console.log( 'Lets now unchain exclusive output l1 -> l2' );

l1.outputUnchain( l2 );

l1.log( 'l1 -> l2 was unchained' );

function onTransformBegin( o )
{
  o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
  hooked += o.input[ 0 ] + '\n';
  return o;
}
