
if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

console.log( 'Please see ExclusiveOutputFromConsole.s first' );
console.log( 'Setup exclusive input from console' );

let l1 = new _.Logger({ name : 'l1' });
l1.inputFrom( console, { exclusiveOutput : 1 } );

console.log( 'This message will not get on screen' );

let l2 = new _.Logger({ name : 'l2' });
l2.outputTo( console, { originalOutput : 1 } );

console.log( 'This message will neither get on screen' );

/*
   originalOutput
  l2   ->   console
*/
l2.log( 'l2 : This message will get on screen' );

l1.outputTo( console, { originalOutput : 1 } );

/*
      exclusiveOutput  originalOutput
 console    ->     l1      ->      console
*/
console.log( 'console : This message will either get on screen' );

