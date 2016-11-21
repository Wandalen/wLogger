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
var Parent = wLogger;
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
