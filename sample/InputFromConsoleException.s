
if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

let l1 = new _.Logger({ name : 'l1' });
let l2 = new _.Logger({ name : 'l2' });

l1.inputFrom( console );
l2.inputFrom( l1 );

console.log( 'After two calls of inputFrom we have a chain: console -> l1 -> l2' );

console.log( 'Now let\'s try to make l2 as input for console.' );
console.log( 'It is going to throw excpetion right now!' );

l2.outputTo( console );

