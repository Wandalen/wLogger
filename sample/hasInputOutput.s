
if( typeof module !== 'undefined' )
require( 'wTools' );

let _ = _global_.wTools;

_.include( 'wLogger' );

let printerA = new _.Logger({ name : 'printerA' });
let printerB = new _.Logger({ name : 'printerB' });

console.log( 'printerA has printerB in outputs:', printerA.hasOutputClose( printerB ) );
console.log( 'Now lets chain two printers, chain will be: printerA -> printerB' )
printerA.outputTo( printerB );
console.log( 'printerA has printerB in outputs:', printerA.hasOutputClose( printerB ) );

console.log( 'printerA has printerB in inputs:', printerA.hasInputClose( printerB ) );
console.log( 'printerB has printerA in inputs:', printerB.hasInputClose( printerA ) );

console.log( 'Lets add new printer to the chain, chain will look like: printerA -> printerB -> printerC' );
var printerC = new _.Logger({ name : 'printerC' });
printerB.outputTo( printerC );

console.log( 'printerA has printerC in outputs:', printerA.hasOutputClose( printerC ) );
console.log( 'printerB has printerC in outputs:', printerB.hasOutputClose( printerC ) );
console.log( 'printerC has printerB in inputs:', printerB.hasInputClose( printerC ) );

console.log( 'printerC exists in the ouput chain of printerA:', printerA.hasOutputDeep( printerC ) );
console.log( 'printerA exists in the input chain of printerC:', printerC.hasInputDeep( printerA ) );

/*
  printerA -> printerB -> printerC

  has*Close - looks only printer's
  has*Deep - looks through all outputs/inputs in the chain

*/