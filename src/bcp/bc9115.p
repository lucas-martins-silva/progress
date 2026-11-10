/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9115 2.00.00.008}  /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9115 MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9115.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Executa um banner para interfaces cacarter de tamanho limitado            **
**                                                                                         **
**   Data......: Fevereiro de 2001 Carlos Pereira                                          **
**                                                                                         **
********************************************************************************************/
Define Input Parameter pNumError            As Integer      Format '999999'     No-undo.
Define Input Parameter pDesError            As Character    Format 'x(256)'     No-undo.
Define Input Parameter pNumLinhas           As Integer                          No-undo.
Define Input Parameter pNumColunas          As Integer                          No-undo.
Define Input Parameter pNumSegundos         As Integer                          No-undo.

Define Variable vQtdLoops                   As Integer                          No-undo.                
Define Variable vByte                       As Integer                          No-undo.                
Define Variable vQtdDisplays                As Integer                          No-undo.                
Define Variable vDisplayCorrente            As Integer                          No-undo.                
Define Variable vConteudoDisplay            As Character View-as Editor Size 16 By 2   No-undo.                
Define Variable vMetadeDoTamanho            As Integer                          No-undo.                
Define Variable vPercorreColunas            As Integer                          No-undo.                
Define Variable vTempo                      As Integer                          No-undo.
Define Variable vTempoIni                   As Integer                          No-undo.
Define Variable vTempoFim                   As Integer                          No-undo.
Define Variable vDesTotalErro               As Character Format 'x(256)'        No-undo.
Define Variable vDesError                   As Character Format 'x(10)'         No-undo.
DEFINE VARIABLE vLogControleEsc             AS LOGICAL                          NO-UNDO.

Define Frame _Error
    vConteudoDisplay at Row 01 Col 01 No-label View-as Editor No-box Size 16 By 2
          With Font 3 No-box Size 16 By 2.

Assign pDesError = pDesError + ' (' + String(pNumError) + ')'.

_VerificaPalavras:
Do  vQtdLoops = 1 To Num-entries(pDesError,''):
    If  Length(Entry(vQtdLoops,pDesError,'')) > (pNumLinhas * pNumColunas) Then Do:
        Assign pDesError = 'M e n s a g e m   p o s s u i  u m a  p a l a v r a   m u i t o   e x t e n s a   p a r a   e s t e   t a m a n h o   d e   d i s p l a y'.
        Leave _VerificaPalavras.
    End.
End.
       
Assign vConteudoDisplay:Width-chars  In Frame _Error = pNumColunas
       vConteudoDisplay:Height-chars In Frame _Error = pNumLinhas
       vConteudoDisplay:Word-wrap    In Frame _Error = No
       Frame _Error    :Width-chars                  = pNumColunas
       Frame _Error    :Height-chars                 = pNumLinhas.

HIDE ALL.
View Frame _Error.
ASSIGN vLogControleEsc = YES.

Do vByte = 1 To Length(pDesError): 
    
    Assign vConteudoDisplay = vConteudoDisplay + Substring(pDesError,vByte,1)
           vDisplayCorrente = vDisplayCorrente + 1.

    If  vDisplayCorrente >= pNumColunas And
        vDisplayCorrente Modulo pNumColunas = 0 Then Do:
        Assign  vConteudoDisplay = vConteudoDisplay + Chr(10).
    End.
    
    If  vDisplayCorrente >= (pNumLinhas * pNumColunas) Then Do:
                     
        If  Substring(pDesError,vByte,1) <> '' Then 
        _palavra:
        Repeat:
            Assign vConteudoDisplay = Substring(vConteudoDisplay,1,(Length(vConteudoDisplay) - 1)).
            If  Substring(pDesError,vByte,1) = '' Then Leave _palavra.
            Assign vByte            = vByte - 1.
        End.           
        
        /*  Data     - Autor - OBS
              09/08/06 - Amarildo - Incluido controle com READKEY, pois caso o usu rio clicasse na tecla ESC 
              enquanto a mensagem era exibida, o sistema perdia o controle do lastkey, causando erro no 
              evento "ON ESC" definido nas frames para abandono.
        */  
        Bell.
         DO WHILE vLogControleEsc = yes:   
           Display vConteudoDisplay With Frame _Error.
           READKEY Pause pNumSegundos.
           IF LASTKEY <> 27 THEN ASSIGN vLogControleEsc = NO.
        END.
        Assign  vConteudoDisplay = ''
                vDisplayCorrente = 0.
        RETURN.
    End.
End.

/*  Data     - Autor - OBS
      09/08/06 - Amarildo - Incluido controle com READKEY, pois caso o usu rio clicasse na tecla ESC 
      enquanto a mensagem era exibida, o sistema perdia o controle do lastkey, causando erro no 
      evento "ON ESC" definido nas frames para abandono.
*/  

assign  vLogControleEsc = yes.
If vConteudoDisplay <> '' Then Do:
    Bell.
    DO WHILE vLogControleEsc = YES:   
       Display vConteudoDisplay With Frame _Error.       
       READKEY PAUSE pNumSegundos.
       IF LASTKEY <> 27 THEN ASSIGN vLogControleEsc = NO.
    END.
    Assign  vConteudoDisplay = ''
            vDisplayCorrente = 0.
    RETURN.
End.

Hide Frame _Error.
