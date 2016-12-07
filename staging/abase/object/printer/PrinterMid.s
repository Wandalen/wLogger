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
var symbolForForeground = Symbol.for( 'foregroundColor' );
var symbolForBackground = Symbol.for( 'backgroundColor' );

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

var _colorConvert = function ( color )
{
  if( !color )
  return null;

  try
  {
    if( !isBrowser )
    color = _.color.rgbFrom( color );
    else
    color = _.color.rgbaFrom( color );
  }
  catch ( err )
  {
    var name = _.color.colorNameNearest( color );
    if( name )
    color = _.color.ColorMap[ name ];
    else
    return null;
  }

  return color;
}

//

var _foregroundColorGet = function()
{
  var self = this;
  return self[ symbolForForeground ];
}

//

var _backgroundColorGet = function()
{
  var self = this;
  return self[ symbolForBackground ];
}

//

var _foregroundColorSet = function( color )
{
  var self = this;
  var style = 'foreground';

  if( !color || color === 'default' )
  {
    if( self._stackIsNotEmpty( style ) )
    self[ symbolForForeground ] = self._stackPop( style );
    else
    self[ symbolForForeground ] = null;
  }
  else
  {
    if( self[ symbolForForeground ] )
    self._stackPush( style, self[ symbolForForeground ] );

    self[ symbolForForeground ] = self._colorConvert( color );
  }
}

//

var _backgroundColorSet = function( color )
{
  var self = this;
  var style = 'background';

  if( !color || color === 'default' )
  {
    if( self._stackIsNotEmpty( style ) )
    self[ symbolForBackground ] = self._stackPop( style );
    else
    self[ symbolForBackground ] = null;
  }
  else
  {
    if( self[ symbolForBackground ] )
    self._stackPush( style, self[ symbolForBackground ] );

    self[ symbolForBackground ] = self._colorConvert( color );
  }
}

//

var _stackPush = function( style, color )
{
  var self = this;

  if( !self.colorsStack )
  {
    self.colorsStack = { 'foreground' : [], 'background' : [] };
  }

  self.colorsStack[ style ].push( color );
}

//

var _stackPop = function( style )
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
        self.foregroundColor = color;
      }
      else if( style === 'background')
      {
        self.backgroundColor = color;
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
        var fg = self.foregroundColor || 'none';
        var bg = self.backgroundColor || 'none';

        result[ 0 ] += `%c${ splitted[ i ] }`;
        result.push( `color:${ _.color.colorToRgbaHtml( fg ) };background:${ _.color.colorToRgbaHtml( bg ) };` );
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
    {
      result +=  splitted[ i ];
    }
    else
    {
      var style = splitted[ i ][ 0 ];
      var color = splitted[ i ][ 1 ];

      if( style === 'foreground')
      {
        self.foregroundColor = color;

        if( self.foregroundColor )
        result += `\x1b[${ self._rgbToCode( self.foregroundColor ) }m`;
        else
        result += `\x1b[39m`;
      }
      else if( style === 'background' )
      {
        self.backgroundColor = color;

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

  _foregroundColorGet : _foregroundColorGet,
  _backgroundColorGet : _backgroundColorGet,

  _foregroundColorSet : _foregroundColorSet,
  _backgroundColorSet : _backgroundColorSet,

  _rgbToCode : _rgbToCode,
  _colorConvert : _colorConvert,
  _onStrip : _onStrip,

  _stackPush : _stackPush,
  _stackPop : _stackPop,
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
