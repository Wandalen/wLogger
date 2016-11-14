(function _LoggerToJstructure_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  if( typeof wLogger === 'undefined' )
  require( './Logger.s' )

}

//


var _ = wTools;
var Parent = wLogger;
var Self = function wLoggerToJstructure()
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

  var nameAct = name + 'Act';

  /* */

  var write = function()
  {
    return this._writeToStruct.apply(this, arguments );
  }

  proto[ name ] = write;
}

//

var _writeToStruct = function()
{
  if( !arguments.length )
  return;

  var data = _.strConcat.apply( {},arguments );
  var _changeLevel = function( arr, level )
  {
    if( !level )
    return arr;
    if( !arr[ 0 ] )
    arr[ 0 ] = [ ];
    return _changeLevel( arr[ 0 ], --level );
  }
  _changeLevel( this.structure, this.level ).push( data );
}

//

var toJson = function()
{
  var self = this;
  return _.toStr( self.structure, { json : 1 } );
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
  outputData : [],
  structure : [],
}

// --
// prototype
// --

var Proto =
{

  init : init,
  init_static : init_static,
  _init_static : _init_static,

  _writeToStruct : _writeToStruct,

  toJson : toJson,

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

Self.prototype.init_static();

// --
// export
// --

if( typeof module !== 'undefined' && module !== null )
{
  module[ 'exports' ] = Self;
}

_global_[ Self.name ] = wTools.LoggerToJstructure = Self;

return Self;

})();
