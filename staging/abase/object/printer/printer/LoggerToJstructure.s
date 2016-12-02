(function _LoggerToJstructure_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  if( typeof wLogger === 'undefined' )
  require( './Logger.s' )

}

var symbolForLevel = Symbol.for( 'level' );

//

/**
 *
 *
 * @classdesc Logger based on [wLogger]{@link wLogger} that writes messages( incoming & outgoing ) to own data structure( array of arrays ).
 *
 * Each inner array represent new level of the structure. On write logger puts messages into structure level which is equal to logger level property value.<br>
 * If needed level not exists logger creates it. Next level is always placed at zero index of previous.<br>
 * <br><b>Methods:</b><br><br>
 * Output:
 * <ul>
 * <li>log
 * <li>error
 * <li>info
 * <li>warn
 * </ul>
 * Leveling:
 * <ul>
 *  <li>Increase current level [up]{@link wPrinterBase.up}
 *  <li>Decrease current level [down]{@link wPrinterBase.down}
 * </ul>
 * Chaining:
 * <ul>
 *  <li>Add object to output list [outputTo]{@link wPrinterBase.outputTo}
 *  <li>Remove object from output list [outputToUnchain]{@link wPrinterBase.outputToUnchain}
 *  <li>Add current logger to target's output list [inputFrom]{@link wPrinterBase.inputFrom}
 *  <li>Remove current logger from target's output list [inputFromUnchain]{@link wPrinterBase.inputFromUnchain}
 * </ul>
 * Other:
 * <ul>
 * <li>Convert data structure to json string [toJson]{@link wLoggerToJstructure.toJson}
 * </ul>
 * @class wLoggerToJstructure
 * @param { Object } o - Options.
 * @param { Object } [ o.output=null ] - Specifies single output object for current logger.
 * @param { Object } [ o.outputData=[ ] ] - Specifies where to write messages.
 *
 * @example
 * var l = new wLoggerToJstructure();
 * l.log( '1' );
 * l.outputData; //returns [ '1' ]
 *
 * @example
 * var data = [];
 * var l = new wLoggerToJstructure({ outputData : data });
 * l.log( '1' );
 * console.log( data ); //returns [ '1' ]
 *
 * @example
 * var l = new wLoggerToJstructure({ output : console });
 * l.log( '1' ); // console prints '1'
 * l.outputData; //returns [ '1' ]
 *

 */

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

  // for( var m = 0 ; m < self.outputChangeLevelMethods.length ; m++ )
  // {
  //   var nameAct = self.outputChangeLevelMethods[ m ] + 'Act';
  //   self[ nameAct ] = function() {};
  // }

  self.currentContainer = self.outputData;

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
// }

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
    this._writeToStruct.apply(this, arguments );
    if( this.output )
    return this[ nameAct ].apply( this,arguments );
  }

  proto[ name ] = write;
}

//

var _writeToStruct = function()
{
  if( !arguments.length )
  return;

  var data = _.strConcat.apply( {}, arguments );

  this.currentContainer.push( data );
}

//

var _levelSet = function( level )
{
  var self = this;

  _.assert( level >= 0, '_levelSet : cant go below zero level to',level );
  _.assert( isFinite( level ) );

  var _changeLevel = function( arr, level )
  {
    if( !level )
    return arr;
    if( !arr[ 0 ] )
    arr[ 0 ] = [ ];
    else if( !_.arrayIs( arr[ 0 ] ) )
    arr.unshift( [] );
    return _changeLevel( arr[ 0 ], --level );
  }

  var dLevel = level - self[ symbolForLevel ];

  // !!! call somewhere
  Parent.prototype._levelSet.call( self,level );

  if( dLevel > 0 )
  {
    // self.upAct( +dLevel );
    self.currentContainer = _changeLevel( self.currentContainer, +dLevel );
  }
  else if( dLevel < 0 )
  {
    // self.downAct( -dLevel );
    self.currentContainer = _changeLevel( self.outputData, level );
  }
  // self[ symbolForLevel ] = level ;
}

//

/**
 * Converts logger data structure to JSON string.
 * @returns Data structure as JSON string.
 *
 * @example
 * var l = new wLoggerToJstructure();
 * l.up( 2 );
 * l.log( '1' );
 * l.toJson();
 * //returns
 * //[
 * // [
 * //  [ '1' ]
 * // ]
 * //]
 * @method toJson
 * @memberof wLoggerToJstructure
 */

var toJson = function()
{
  var self = this;
  return _.toStr( self.outputData, { json : 1 } );
}

// --
// relationships
// --

var Composes =
{
}

var Aggregates =
{
  outputData : [],
}

var Associates =
{
}

var Restricts =
{
  currentContainer : null
}

// --
// prototype
// --

var Proto =
{

  init : init,
  //init_static : init_static,
  _init_static : _init_static,

  _writeToStruct : _writeToStruct,
  _levelSet : _levelSet,

  toJson : toJson,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,

}

//

_.protoMake
({
  constructor : Self,
  parent : Parent,
  extend : Proto,
});

Self.prototype.init_static();

//

_.accessor
({
  object : Self.prototype,
  names :
  {
    level : 'level',
  },
  combining : 'rewrite'
});

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
