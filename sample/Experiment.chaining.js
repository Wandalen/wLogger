if( typeof module !== 'undefined' )
require( 'wLogger' );

var _ = _global_.wTools;

var bar =  _.Logger.consoleBar({ outputLogger : logger, bar : 1 });

var l = new _.Logger({ output : null });
l.inputFrom( console );
// l.inputUnchain( console );

bar.bar = 0;
_.Logger.consoleBar( bar );

_.Logger.consoleBar({ outputLogger : logger, bar : 1 });

console.log( 1 )