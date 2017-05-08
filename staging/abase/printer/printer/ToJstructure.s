(function _PrinterToJstructure_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  // if( typeof wBase === 'undefined' )
  try
  {
    require( '../../wTools.s' );
  }
  catch( err )
  {
    require( 'wTools' );
  }

  var _ = wTools;

  _.include( 'wLogger' );

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
 *  <li>Increase current level [up]{@link wPrinterMid.up}
 *  <li>Decrease current level [down]{@link wPrinterMid.down}
 * </ul>
 * Chaining:
 * <ul>
 *  <li>Add object to output list [outputTo]{@link wPrinterMid.outputTo}
 *  <li>Remove object from output list [outputUnchain]{@link wPrinterMid.outputUnchain}
 *  <li>Add current logger to target's output list [inputFrom]{@link wPrinterMid.inputFrom}
 *  <li>Remove current logger from target's output list [inputUnchain]{@link wPrinterMid.inputUnchain}
 * </ul>
 * Other:
 * <ul>
 * <li>Convert data structure to json string [toJson]{@link wPrinterToJstructure.toJson}
 * </ul>
 * @class wPrinterToJstructure
 * @param { Object } o - Options.
 * @param { Object } [ o.output=null ] - Specifies single output object for current logger.
 * @param { Object } [ o.outputData=[ ] ] - Specifies where to write messages.
 *
 * @example
 * var l = new wPrinterToJstructure();
 * l.log( '1' );
 * l.outputData; //returns [ '1' ]
 *
 * @example
 * var data = [];
 * var l = new wPrinterToJstructure({ outputData : data });
 * l.log( '1' );
 * console.log( data ); //returns [ '1' ]
 *
 * @example
 * var l = new wPrinterToJstructure({ output : console });
 * l.log( '1' ); // console prints '1'
 * l.outputData; //returns [ '1' ]
 *

 */

var _ = wTools;
var Parent = wPrinterTop;
var Self = function wPrinterToJstructure( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterToJstructure';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

  self._currentContainer = self.outputData;

}

//

function write()
{
  var self = this;

  debugger;
  var o = wPrinterBase.prototype.write.apply( self,arguments );

  if( !o )
  return;

  _.assert( o );
  _.assert( _.arrayIs( o.output ) );
  _.assert( o.output.length === 1 );

  var terminal = o.output[ 0 ];
  if( self.usingTags && _.mapKeys( self.attributes ).length )
  {

    var text = terminal;
    terminal = Object.create( null );
    terminal.text = text;

    for( var t in self.attributes )
    {
      terminal[ t ] = self.attributes[ t ];
    }

  }

  this._currentContainer.push( terminal );

  return o;
}

//

function levelSet( level )
{
  var self = this;

  _.assert( level >= 0, 'levelSet : cant go below zero level to',level );
  _.assert( isFinite( level ) );

  // function _changeLevel( arr, level )
  // {
  //   if( !level )
  //   return arr;
  //
  //   if( !arr[ 0 ] )
  //   arr[ 0 ] = [ ];
  //   else if( !_.arrayIs( arr[ 0 ] ) )
  //   arr.unshift( [] );
  //
  //   return _changeLevel( arr[ 0 ], --level );
  // }

  var dLevel = level - self[ symbolForLevel ];

  Parent.prototype.levelSet.call( self,level );

  if( dLevel > 0 )
  {
    for( var l = 0 ; l < dLevel ; l++ )
    {
      var newContainer = [];
      self._currentContainers.push( self._currentContainer );
      self._currentContainer.push( newContainer );
      self._currentContainer = newContainer;
    }
  }
  else if( dLevel < 0 )
  {
    self._currentContainer = self._currentContainers[ self._currentContainers.length+dLevel ];
    _.assert( _.arrayLike( self._currentContainer ) || _.objectLike( self._currentContainer ) );
    _.assert( self._currentContainers.length >= -dLevel );
    self._currentContainers.splice( self._currentContainers.length+dLevel,self._currentContainers.length );
    if( level === 0 )
    _.assert( self._currentContainers.length === 0 );
  }

}

//

/**
 * Converts logger data structure to JSON string.
 * @returns Data structure as JSON string.
 *
 * @example
 * var l = new wPrinterToJstructure();
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
 * @memberof wPrinterToJstructure
 */

function toJson()
{
  var self = this;
  return _.toStr( self.outputData, { json : 1 } );
}

// --
// relationships
// --

var Composes =
{
  usingTags : 1,
  // writingAttributesIntoTerminals : 1,
  // writingAttributesIntoBranches : 1,
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
  _currentContainer : null,
  _currentContainers : [],
}

// --
// prototype
// --

var Proto =
{

  init : init,

  // __initChainingMixinWrite : __initChainingMixinWrite,
  // _writeToStruct : _writeToStruct,

  write : write,

  levelSet : levelSet,

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

// Self.prototype._initChainingMixin();

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

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

})();
