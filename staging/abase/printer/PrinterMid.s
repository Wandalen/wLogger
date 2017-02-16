(function _PrinterMid_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof wPrinterMid !== 'undefined' )
  return;

  if( typeof wPrinterBase === 'undefined' )
  require( './PrinterBase.s' );

  require( './aChainingMixin.s' )

  var _ = wTools;

  _.include( 'wCopyable' );

}

//

/**
 * @class wPrinterMid
 */

var _ = wTools;
var Parent = wPrinterBase;
var Self = function wPrinterMid( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterMid';

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );

  self.levelSet( self.level );

}

//

function levelSet( level )
{
  var self = this;

  Parent.prototype.levelSet.call( self,level );

  var level = self[ symbolForLevel ];

  self._prefix = _.strTimes( self._dprefix || '',level );
  self._postfix = _.strTimes( self._dpostfix|| '',level );

}

//

function begin()
{
  var self = this;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var tag = arguments[ a ];
    _.assert( _.strIs( tag ) );
    self.tags[ tag ] = 1;
  }

  return self;
}

//

function end()
{
  var self = this;

  for( var a = 0 ; a < arguments.length ; a++ )
  {
    var tag = arguments[ a ];
    _.assert( _.strIs( tag ) );
    self.tags[ tag ] = 0;
  }

  return self;
}

// --
// relationships
// --

var symbolForLevel = Symbol.for( 'level' );

var Composes =
{

  // outputs : [],
  // inputs : [],

  _prefix : '',
  _postfix : '',

  _dprefix : '  ',
  _dpostfix : '',

  tags : {},

}

var Aggregates =
{
}

var Associates =
{
}

// --
// prototype
// --

var Proto =
{

  // routine

  init : init,

  levelSet : levelSet,

  begin : begin,
  end : end,


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

_.assert( Self.prototype.init === init );

//

_.accessorForbid
({
  object : Self.prototype,
  names :
  {
    format : 'format',
  }
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools[ Self.nameShort ] = Self;

return Self;

})();
