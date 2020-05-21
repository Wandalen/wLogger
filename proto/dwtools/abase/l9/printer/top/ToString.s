(function _ToString_s_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../../../dwtools/Tools.s' );

  _.include( 'wLogger' );

}

//

/**
 * @classdesc Creates a printer that collects messages into a single string. Based on [wPrinterTop]{@link wPrinterTop}.
 * @class wPrinterToString
 * @module Tools/base/Logger
 */

var _global = _global_;
var _ = _global_.wTools;
var Parent = _.PrinterTop;
var Self = function wPrinterToString( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PrinterToString';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

}

//

function write()
{
  var self = this;

  var o = _.PrinterBase.prototype.write.apply( self,arguments );

  _.assert( _.arrayIs( o.output ) );
  _.assert( o.output.length === 1 );
  _.assert( _.strIs( o.pure ) );

  self.outputData += o.pure;

  return o;
}

// --
// relations
// --

var Composes =
{
}

var Aggregates =
{
  outputData : '',
}

var Associates =
{
}

var Restricts =
{
}

// --
// prototype
// --

var Proto =
{

  init,

  write,

  // relations

  /* constructor * : * Self, */
  Composes,
  Aggregates,
  Associates,
  Restricts,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_global_[ Self.name ] = _[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;
_global_[ Self.name ] = _[ Self.shortName ] = Self;

})();
