
/* qqq : try to do multiple original/exclusive output in different order */
/* qqq : double check returns */
/* qqq : redundant vars and routines */
/* qqq : finit should unchain everything */

let _ = require( '../include/dwtools/Base.s' );

_.include( 'wLogger' );

let hooked = '';

console.log( 'Please see ExclusiveOutputFromConsole.s first' );
console.log( 'Setup exclusive input from console' );

let l1 = new _.Logger({ name : 'l1' });
l1.inputFrom( console, { exclusiveOutput : 1 } );

console.log( 'This message will not get on screen' );

let l2 = new _.Logger({ name : 'l2' });
l2.outputTo( console, { originalOutput : 1 } );

console.log( 'This message will neither get on screen' );
l2.log( 'This message will get on screen' );

l1.outputTo( console, { originalOutput : 1 } );

l2.log( 'This message will either get on screen' );
console.log( 'This message will either get on screen' );
l2.log( 'This message will either get on screen' );
