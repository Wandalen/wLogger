
require( 'wLogger' );
let _ = _global_.wTools;

var reset = `\x1b[0;0m`

/*  clear screen */

// console.log( 'a\nb\nc' );
// console.log( `\x1b[2J\x1b[;H` );

/*  all to defaults */

// console.log( `\x1b[35;m\x1b[43;m`, 'text', reset, 'text' );

/*
    Crossed-out :
    windows -
    linux ?
    mac ?
*/

console.log( `\x1b[9m`, 'crossed', reset, 'not crossed' );

/*
    italic :
    windows -
    linux ?
    mac ?
*/

console.log( `\x1b[3m`, 'italic', reset , 'not italic');

/*
    underline :
    windows +
    linux ?
    mac ?
*/

console.log( `\x1b[4m`, 'underline', reset );

/*
    alternative font :
    windows -
    linux ?
    mac ?
*/

console.log( `\x1b[11m`, 'alternative font', reset );

/*
    swap fg/bg :
    windows +, can't use swap to reverse change
    linux ?
    mac ?
*/

var swap = `\x1b[7m`
console.log( `\x1b[35;m\x1b[43;m`, 'normal', swap, 'swaped', swap, 'normal', reset );

/*
    framed :
    windows -
    linux ?
    mac ?
*/

console.log( `\x1b[51m`, 'framed', reset );

