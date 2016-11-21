(function _LoggerToFile_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  if( typeof wLogger === 'undefined' )
  require( './Logger.s' )

  require( 'wFiles' )

}

//

var _ = wTools;
var Parent = wPrinterMid;
/**
 * @classdesc Logger based on [wLogger]{@link wLogger} that writes messages( incoming & outgoing ) to file specified by path( outputPath ).
 *
 * Writes each message to the end of file. Creates new file( outputPath ) if it doesn't exists.
 *
 * <br><b>Methods:</b><br><br>
 * Output:
 * <ul>
 * <li>log
 * <li>error
 * <li>info
 * <li>warn
 * </ul>
 * Chaining:
 * <ul>
 *  <li>Add object to output list [outputTo]{@link wPrinterBase.outputTo}
 *  <li>Remove object from output list [unOutputTo]{@link wPrinterBase.unOutputTo}
 *  <li>Add current logger to target's output list [inputFrom]{@link wPrinterBase.inputFrom}
 *  <li>Remove current logger from target's output list [unInputFrom]{@link wPrinterBase.unInputFrom}
 * </ul>
 * @class wLoggerToFile
 * @param { Object } o - Options.
 * @param { Object } [ o.output=null ] - Specifies single output object for current logger.
 * @param { Object } [ o.outputPath=null ] - Specifies file path for output.
 *
 * @example
 * var path = __dirname +'/out.txt';
 * var l = new wLoggerToJstructure({ outputPath : path });
 * var File = _.FileProvider.HardDrive();
 * l.log( '1' );
 * FilefileReadAct
 * ({
 *  pathFile : path,
 *  sync : 1
 * });
 * //returns '1'
 *
 * @example
 * var path = __dirname +'/out2.txt';
 * var l = new wLoggerToJstructure({ outputPath : path });
 * vae l2 = new wLogger({ output : l });
 * var File = _.FileProvider.HardDrive();
 * l2.log( '1' );
 * FilefileReadAct
 * ({
 *  pathFile : path,
 *  sync : 1
 * });
 * //returns '1'
 *
 */
var Self = function wLoggerToFile()
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

//

var init = function( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

  debugger;
  if( typeof __dirname !== 'undefined' )
  self.outputPath = _.pathJoin( _.pathBaseDir(),self.outputPath );

  // what is it for?
  // if( self.output )
  // self.outputTo( self.output );

}

//

// var init_static = function()
// {
//   var proto = this;
//   _.assert( Object.hasOwnProperty.call( proto,'constructor' ) );
//
//   for( var m = 0 ; m < proto.outputWriteMethods.length ; m++ )
//   proto._init_static( proto.outputWriteMethods[ m ] );
//
//   // for( var m = 0 ; m < proto.outputChangeLevelMethods.length ; m++ )
//   // {
//   //   var name = proto.outputChangeLevelMethods[ m ];
//   //   proto[ name ] = null;
//   // }
//
// }

//

var _init_static = function( name )
{
  var proto = this;
  var nameAct = name + 'Act';

  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) )
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ) );

  /* */

  var write = function()
  {
    this._writeToFile.apply( this, arguments );
    if( this.output )
    return this[ nameAct ].apply( this,arguments );
  }

  proto[ name ] = write;
}

//

var _writeToFile = function ( )
{
  var self = this;

  _.assert( arguments.length );
  _.assert( _.strIs( self.outputPath ),'outputPath is not defined for LoggerToFile' );

  if( !self.fileProvider )
  self.fileProvider = _.FileProvider.HardDrive();

  var data = _.strConcat.apply( { },arguments ) + '\n';

  self.fileProvider.fileWriteAct
  ({
    pathFile :  self.outputPath,
    data : data,
    writeMode : 'append',
    sync : 1
  });

}

//

var up = function(){};

//

var down = function(){};

// --
// relationships
// --

var Composes =
{
  outputPath : 'output.log',
}

var Aggregates =
{
}

var Associates =
{
  fileProvider : null,
}

// --
// prototype
// --

var Proto =
{

  init : init,

  // init_static : init_static,
  _init_static : _init_static,

  _writeToFile : _writeToFile,
  up : up,
  down : down,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

debugger;
Self.prototype.init_static();

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

_global_[ Self.name ] = wTools.LoggerToFile = Self;

})();
