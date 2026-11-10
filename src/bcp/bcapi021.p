/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI021 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI021 MUT}
&ENDIF


/* 
   procedure para linguagens PCL3 para impressoras lazer para possibilitar 
   impressÆo de codigo de barra padrÆo code39 e code 2of5
*/

/*------------------------------------------------------------------*/

Define variable v_log_impl_cl   As logical  no-undo.

{cdp/cdapi523.i h-param-global} 
run cdp/cdapi523.p persistent set h-param-global. /* Magnus */

if  valid-handle(h-param-global) then do:

    if return-value = "OK" then do:     /* Existe Param-Global */
        assign v_log_impl_cl = modulo-cl().

        if not v_log_impl_cl then do:
            run utp/ut-msgs.p (input "msg",
                               input 31638,
                               INPUT "").
            RETURN "31638 - ":U + RETURN-VALUE.              
        end. /* if */

    end. /* if */
    else do:
        run utp/ut-msgs.p (input "msg",
                           input 31638,
                           INPUT "").
        RETURN "31638 - ":U + RETURN-VALUE.              
    end. /* else */
end.
delete procedure h-param-global.

find first param-bc no-lock no-error.
if NOT available param-bc then do:
    run utp/ut-msgs.p (input "msg",
                       input 31638,
                       INPUT "").
    RETURN "31638 - ":U + RETURN-VALUE.        
END.
RETURN "OK":U.


/******************************************************************************/
/*                                                                            */
/*              Create barcode, 39 for HP                                     */
/*                                                                            */
/* The procedure creates ESC-sequences for a barcode in Code39 format         */
/* The printer cursor position is restored after printing.                    */
/*                                                                            */
/* Input:  kar      as char no-undo.         The char string to translate     */
/*         spec     as char no-undo.         Barcode spec. see later          */
/*         macronr  as char no-undo.         Number of the makro, if you want */
/*                                           one, otherwise blank             */
/* Output: bar      as char no-undo.         The generated barcode            */
/*                                                                            */
/* Structure of spec:                                                         */
/*         1.    P for horizontal barcode                                     */
/*               L for vertical barcode                                       */
/*         2-3   width of small bars and spaces in dots (norm 03)             */
/*         4-5   width of wide bars and spaces in dots (norm 07-08)           */
/*         6-    Height of barcode in dots (norm 80)                          */
/*                                                                            */
/******************************************************************************/

procedure pi-codigo-code39:
  def input  parameter kar   as char no-undo.
  def input  parameter spec  as char no-undo.
  def input  parameter macno as char no-undo.
  def output parameter bar   as char no-undo.

  def var clr as log init true no-undo.
  def var wk  as cha no-undo.
  def var drw as cha no-undo.
  def var dir as cha no-undo.
  def var k   as cha no-undo.
  def var kod as cha init "1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ.Ø *$/+%" no-undo.
  def var att as cha no-undo.

  att = "100100001001100001101100000000110001100110000001110000000100101100100100".
  att = att + "001100100000110100100001001001001001101001000000011001100011000001011000".
  att = att + "000001101100001100001001100000011100100000011001000011101000010000010011".
  att = att + "100010010001010010000000111100000110001000110000010110110000001011000001".
  att = att + "111000000010010001110010000011010000010000101110000100011000100010010100".
  att = att + "010101000010100010010001010000101010".

  def var i   as int no-undo.
  def var j   as int no-undo.
  def var l   as int no-undo.
  def var brd as int no-undo.
  def var jst as int no-undo.
  assign
    i   = if substr(spec,1,1)="P":u then 1 else 2
    bar = (if macno <> "" then "~E&f":u + macno + "y8X~E&f":u + macno +
          "y0X":u  else "":u) + "~E&f0S~E*c100G":u
    drw = substr("ab":u,i,1) + substr(spec,6) + substr("ba":u,i,1) + "P":u
    dir = substr("XY":u,i,1)
    k   = "*" + kar + "*":u.
  do i = 1 to length(k):
    j = index(kod,substr(k,i,1)) * 9 - 8.
    wk = substr(att,j,9) + "0".
    do l = 1 to 10:
      assign
        brd = if substr(wk,l,1) = "0":u then 2 else 4
        bar = if clr then
                bar + "~E*c":u + substr(spec,brd,2) + drw
              else
                bar + "~E*p+":u + string(integer(substr(spec,brd,2)) + jst) + dir
        jst = integer(substr(spec,brd,2))
        clr = not clr.
    end.
  end.
  assign
    bar = bar + "~E&f1S":u + (if macno <> "" then "~E&f1X~E&f":u + macno + "y9X":u else "")
    wk = "":u.
end.


/*---------------------------------------------------------*/


/******************************************************************************/
/*                                                                            */
/*              Dan stregkode, 2of5 interleaved til HP                        */
/*                                                                            */
/* Proceduren laver ESC-sekvenserne til en stregkode i 2 of 5 interleaved.    */
/* Stregkoden 'fylder' ikke noget p† printet - d.v.s. at printpositionen ikke */
/* ‘ndres, n†r koden skrives.                                                 */
/*                                                                            */
/* Input:  kar      as char no-undo.         Koden, der skal oms?ttes         */
/*         spec     as char no-undo.         Barkodespecifikation se nedenst. */
/*         macronr  as char no-undo.         Nummer p† makro, hvis en s†dan   */
/*                                           skal bygges, ellers blank        */
/* Output: bar      as char no-undo.         Den genererede stregkode         */
/*                                                                            */
/* Opbygning af spec:                                                         */
/*         1.    P for vandret stregkode                                      */
/*               L for lodret  stregkode.                                     */
/*         2-3   bredde af smalle streger og mellemrum i dots (norm 03)       */
/*         4-5   bredde af tykke  streger og mellemrum i dots (norm 07-08)    */
/*         6-    H›jden af stregkoden i antal dots (norm 80)                  */
/*                                                                            */
/******************************************************************************/


procedure pi-codigo-code2of5:

  def input  parameter kar   as char no-undo.
  def input  parameter spec  as char no-undo.
  def input  parameter macno as char no-undo.
  def output parameter bar   as char no-undo.

  def var clr as log init true no-undo.
  def var wk  as cha no-undo.
  def var drw as cha no-undo.
  def var dir as cha no-undo.
  def var att as cha init "00110100010100111000001011010001100000111001001010":u.
  def var i   as int no-undo.
  def var j   as int no-undo.
  def var k   as int no-undo.
  def var l   as int no-undo.
  def var brd as int no-undo.
  def var jst as int no-undo.
  assign
    i   = if substr(spec,1,1)="P":u then 1 else 2
    bar = (if macno <> "" then "~E&f":u + macno + "y8X~E&f":u + macno + "y0X":u  else "":u) + "~E&f0S~E*c100G":u
    drw = substr("ab":u,i,1) + substr(spec,6) + substr("ba":u,i,1) + "P":u
    dir = substr("XY":u,i,1)
    wk  = "0000":u.
  do i = 1 to length(kar) by 2:
    assign
      j = (asc(substr(kar,i    ,1)) - 47) * 5 - 4
      k = (asc(substr(kar,i + 1,1)) - 47) * 5 - 4.
    do l = 0 to 4:
      wk = wk + substr(att,j + l,1) + substr(att,k + l,1).
      end.
    end.
  wk = wk + "100":u.
  do i = 1 to length(wk):
    assign
      brd = if substr(wk,i,1) = "0":u then 2 else 4
      bar = if clr then
              bar + "~E*c":u + substr(spec,brd,2) + drw
            else
              bar + "~E*p+":u + string(integer(substr(spec,brd,2)) + jst) + dir
      jst = integer(substr(spec,brd,2))
      clr = not clr.
    end.
  assign
    bar = bar + "~E&f1S":u + (if macno <> "" then "~E&f1X~E&f":u + macno + "y9X":u else "")
    wk = "":u.
end.
