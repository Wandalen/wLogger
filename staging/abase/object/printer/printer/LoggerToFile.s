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
var File = _.FileProvider.HardDrive();
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

  if( self.output )
  self.outputTo( self.output );

}

var init_static = function()
{
  var proto = this;
  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) );

  for( var m = 0 ; m < proto.outputWriteMethods.length ; m++ )
  proto._init_static( proto.outputWriteMethods[ m ] );

}

//

var _init_static = function( name )
{
  var proto = this;

  _.assert( Object.hasOwnProperty.call( proto,'constructor' ) )
  _.assert( arguments.length === 1 );
  _.assert( _.strIs( name ) );

  /* */

  var write = function()
  {
    return this._writeToFile.apply(this, arguments );
  }

  proto[ name ] = write;
}

//

var _writeToFile = function ( )
{
  var self = this;
  _.assert( _.strIs( arguments[ 0 ] ) );
  _.assert( _.strIs( self.outputPath ) );

  File.fileWriteAct
  ({
    pathFile :  self.outputPath,
    data : arguments[ 0 ],
    writeMode : 'append',
    sync : 1
  });
}

// --
// relationships
// --

var Composes =
{
}

var Aggregates =
{
}

var Associates =
{
  output : console,
  outputPath : null,
}



// --
// prototype
// --

var Proto =
{

  init : init,
  init_static : init_static,
  _init_static : _init_static,

  // relationships

  _writeToFile : _writeToFile,
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

Self.prototype.init_static();

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

_global_[ Self.name ] = wTools.LoggerToFile = Self;

return Self;

})();
