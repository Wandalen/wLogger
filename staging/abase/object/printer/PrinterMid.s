(function _PrinterMid_s_() {

'use strict';

var Chalk;
var isBrowser = true;
if( typeof module !== 'undefined' )
{

  isBrowser = false;

  if( typeof wPrinterBase === 'undefined' )
  require( './PrinterBase.s' )

  try
  {
    require( 'wColor' );
  }
  catch( err )
  {
  }

}

var symbolForLevel = Symbol.for( 'level' );

//

var _ = wTools;
var Parent = wPrinterBase;
var Self = function wPrinterMid()
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

}

//

var _rgbToCode = function( rgb )
{
  var r = rgb[ 0 ];
  var g = rgb[ 1 ];
  var b = rgb[ 2 ];

  var ansi = 30 + ( ( Math.round( b ) << 2 ) | (Math.round( g ) << 1 ) | Math.round( r ) );

  return ansi;
}

//

var _onStrip = function( strip )
{
  var allowedKeys = [ 'bg','background','fg','foreground' ];
  var parts = strip.split( ' : ' )
  if( parts.length === 2 )
  {
    if( allowedKeys.indexOf( parts[ 0 ] ) === -1 )
    return;
    return parts;
  }
}

//

var colorForegroundGet = function()
{
  var self = this;
  return self.foregroundColor;
}

//

var colorBackgroundGet = function()
{
  var self = this;
  return self.backgroundColor;
}

//

var _addToStack = function( color, style )
{
  var self = this;

  if( !self.colorsStack )
  {
    self.colorsStack = { 'foreground' : [], 'background' : [] };
  }

  self.colorsStack[ style ].push( color );
}

//

var _getFromStack = function( style )
{
  var self = this;

  return self.colorsStack[ style ].pop();
}

//

var _stackIsNotEmpty = function( style )
{
  var self = this;
  if( self.colorsStack && self.colorsStack[ style ].length )
  return true;

  return false;
}

//

var _writeDoingBrowser = function( str )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var result = [ '' ];

  var splitted = _.strExtractStrips( str, { onStrip : self._onStrip } );
  if( splitted.length === 1 && !self._isStyled )
  {
    if( !_.arrayIs( splitted[ 0 ] ) )
    return splitted;
  }

  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.arrayIs( splitted[ i ] ) )
    {
      var style = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( style === 'foreground')
      {
        if( color === 'default' )
        {
          if( self._stackIsNotEmpty( style ) )
          self.foregroundColor = self._getFromStack( style )
          else
          self.foregroundColor = null;
        }
        else
        {
          if( self.foregroundColor )
          self._addToStack( self.foregroundColor, style )

          self.foregroundColor = _.color.rgbFrom( color );
        }
      }
      else if( style === 'background')
      {
        if( color === 'default' )
        {
          if( self._stackIsNotEmpty( style ) )
          self.backgroundColor = self._getFromStack( style )
          else
          self.backgroundColor = null;
        }
        else
        {
          if( self.backgroundColor )
          self._addToStack( self.backgroundColor, style )

          self.backgroundColor = _.color.rgbFrom( color );
        }
      }
      if( !self.foregroundColor && !self.backgroundColor )
      self._isStyled = 0;
      else if( !!self.foregroundColor | !!self.backgroundColor )
      self._isStyled = 1;
    }
    else
    {
      if( !i && !self._isStyled )
      {
        result[ 0 ] += splitted[ i ];
      }
      else
      {
        if( !self.foregroundColor )
        self.foregroundColor = 'none';
        if( !self.backgroundColor )
        self.backgroundColor = 'none';

        result[ 0 ] += `%c${ splitted[ i ] }`;
        result.push( `color:${ _.color.colorToRgbHtml( self.foregroundColor ) };background:${ _.color.colorToRgbHtml( self.backgroundColor ) };` );
      }
    }
  }

  if( !result[ 0 ].length )
  return [];
  return result;
}

//

var _writeDoingShell = function( str )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var result = '';

  var splitted = _.strExtractStrips( str, { onStrip : self._onStrip } );

  for( var i = 0; i < splitted.length; i++ )
  {
    if( _.strIs( splitted[ i ] ) )
    result += splitted[ i ];
    else
    {
      var style = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( color && color != 'default' )
      {
        color = _.color.rgbaFrom( color );
      }

      if( !color )
      color = 'default';

      if( style === 'foreground')
      {
        if( color !== 'default' )
        {
          if( self.foregroundColor )
          self._addToStack( self.foregroundColor, style );

          self.foregroundColor = color;
        }
        else
        {
          if( self._stackIsNotEmpty( style ) )
          self.foregroundColor = self._getFromStack( style );
          else
          self.foregroundColor = null;
        }

        if( self.foregroundColor )
        result += `\x1b[${ self._rgbToCode( self.foregroundColor ) }m`;
        else
        result += `\x1b[39m`;
      }
      else if( style === 'background' )
      {
        if( color !== 'default' )
        {
          if( self.backgroundColor )
          self._addToStack( self.backgroundColor, style );

          self.backgroundColor = color;
        }
        else
        {
          if( self._stackIsNotEmpty( style ) )
          self.backgroundColor = self._getFromStack( style );
          else
          self.backgroundColor = null;
        }

        if( self.backgroundColor )
        result += `\x1b[${ self._rgbToCode( self.backgroundColor ) + 10 }m`;
        else
        result += `\x1b[49m`;
      }
    }
  }

  return [ result ];
}

//

var writeDoing = function( args )
{
  var self = this;

  _.assert( arguments.length === 1 );

  var optionsForStr =
  {
    linePrefix : self._prefix,
    linePostfix : self._postfix,
  }

  var result = _.strConcat.apply( optionsForStr,args );

  if( !isBrowser )
  result = self._writeDoingShell( result );
  else
  result = self._writeDoingBrowser( result );

  return result;
}

//

var _levelSet = function( level )
{
  var self = this;

  _.assert( isFinite( level ) );

  Parent.prototype._levelSet.call( self,level );

  var level = self[ symbolForLevel ];

  self._prefix = _.strTimes( self._dprefix,level );
  self._postfix = _.strTimes( self._dpostfix,level );

}

//

var topic = ( function()
{

  return function topic()
  {
    var self = this;

    debugger;

    var s = _.str.apply( _,arguments );

    if( Chalk === undefined && typeof module !== 'undefined' )
    try
    {
      Chalk = require( 'chalk' );
    }
    catch( err ) 
    {
      Chalk = null;
    }

    if( Chalk )
    s = Chalk.bgWhite( Chalk.black( s ) );

    this.log();
    this.log( s );
    this.log();

    return s;
  }

})();

// --
// relationships
// --

var Composes =
{

  _prefix : '',
  _postfix : '',

  _dprefix : '  ',
  _dpostfix : '',

  foregroundColor : null,
  backgroundColor : null,

  colorsStack : null,

  _colorTable : null,
  _isStyled : 0

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

  colorForegroundGet : colorForegroundGet,
  colorBackgroundGet : colorBackgroundGet,

  _rgbToCode : _rgbToCode,
  _onStrip : _onStrip,

  _addToStack : _addToStack,
  _getFromStack : _getFromStack,
  _stackIsNotEmpty : _stackIsNotEmpty,

  _writeDoingShell : _writeDoingShell,
  _writeDoingBrowser : _writeDoingBrowser,

  writeDoing : writeDoing,

  _levelSet : _levelSet,

  topic : topic,

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

//

_.accessor
({
  object : Self.prototype,
  combining : 'rewrite',
  names :
  {
    level : 'level',
    foregroundColor : 'foregroundColor',
    backgroundColor : 'backgroundColor',
  }
});

// export

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

_global_[ Self.name ] = wTools.PrinterMid = Self;

return Self;

})();
