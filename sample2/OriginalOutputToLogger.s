
/* qqq : pay attention on difference between ExclusiveOutputFromConsole and ExclusiveOutputFromLogger */

if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

console.log( 'Please see ExclusiveOutputFromConsole.s first' );
console.log( 'Setup exclusive input from logger l1 -> l2' );

let l1 = new _.Logger({ name : 'l1' });
let l2 = new _.Logger({ name : 'l2' });

l1.outputTo( console );
l1.outputTo( l2, { exclusiveOutput : 1 } );

l1.log( 'This message will not get on screen' );

let l3 = new _.Logger({ name : 'l3' });
// l3.outputTo( l1, { originalOutput : 1 } );
l1.inputFrom( l3, { originalOutput : 1 } );

l1.log( 'This message will neither get on screen' );
l3.log( 'This message will get on screen' );

/*
    Chain:

       originalOutput    exclusiveOutput
    l3      →       l1     →     l2

          ordinary  ↓

                 console
*/
