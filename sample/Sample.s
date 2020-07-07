
require( 'wLogger' );
let _ = _global_.wTools;

let l1 = new _.Logger();
l1.outputTo( console );
l1.log( 'hello' );
