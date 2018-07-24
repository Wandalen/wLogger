
/* qqq : make it nicer */

let _ = require( '../include/dwtools/Base.s' );

_.include( 'wLogger' );

let hooked = '';
let outputPrinter = new _.Logger({ name : 'outputPrinter', onTransformEnd : onTransformEnd });
let barPrinter = new _.Logger({ name : 'barPrinter', onTransformEnd : onTransformEnd });

var bar = _.Logger.consoleBar
({
  outputPrinter : outputPrinter,
  barPrinter : barPrinter,
});

console.log( 'console.log' );
outputPrinter.log( 'outputPrinter.log' );

bar.on = 0;
_.Logger.consoleBar( bar )

console.log( 'console.log' );
outputPrinter.log( 'outputPrinter.log' );

function onTransformEnd( o )
{
  o.input[ 0 ] = this.name + ' : ' + o.input[ 0 ];
  hooked += o.input[ 0 ] + '\n';
  return o;
}
