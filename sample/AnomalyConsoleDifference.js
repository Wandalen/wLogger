
// if( typeof module !== 'undefined' )
var wLogger = require( '../staging/abase/object/printer/printer/Logger.s' );
var LoggerExperiment = require( '../staging/abase/object/printer/printer/LoggerExperiment.s' );
//require( 'wLogger' );

var _ = wTools;
var l1 = new wLogger();
l1.outputTo( console, { combining : 'append' } );

console.log( 'output',wLogger.prototype.Associates.output === console );

console.log( 'wLogger.outputs.length:',l1.outputs.length ); //returns 2
console.log( 'wLogger.outputs.output[0] === console:',l1.outputs[ 0 ].output === console  ) // returns false
console.log( 'wLogger.outputs.output[0] === outputs.output[1]:',l1.outputs[ 0 ].output === l1.outputs[ 1 ].output  ) // returns false

return;

/*Composes output : null, self.outputTo( console ) placed into init function*/
var l2 = new LoggerExperiment();
l2.outputTo( console, { combining : 'append' } );//returns false
console.log( '\nLoggerExperiment.outputs.length:',l2.outputs.length );//returns 1
console.log( 'LoggerExperiment.output === console:',l2.output === console );//returns true
