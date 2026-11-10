/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM9058 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM9058 MIM}
&ENDIF

{cdp/cdcfgmat.i}
{cdp/cd4300.i3}   /* include tratamento atributo livre */
{rep/re1001a.i50} /* include tratamento atributo livre docum-est.char-1 */ 


DEFINE INPUT  PARAMETER pr-rowid-nf   AS   ROWID                     NO-UNDO.
DEFINE OUTPUT PARAMETER c-observ-nota LIKE nota-fiscal.observ-nota   NO-UNDO.

DEFINE BUFFER bf-docum-est-nota FOR docum-est.
DEFINE BUFFER bf-docum-est-mae  FOR docum-est.
DEFINE BUFFER bf-nota-fiscal    FOR nota-fiscal.

DEFINE VARIABLE c-embarque-pai LIKE embarque-imp.embarque NO-UNDO.

FIND FIRST nota-fiscal
     WHERE ROWID(nota-fiscal) = pr-rowid-nf NO-LOCK NO-ERROR.
IF AVAIL nota-fiscal THEN DO:

    FIND FIRST docum-est 
         WHERE docum-est.serie-docto  = nota-fiscal.serie
           AND docum-est.nro-docto    = nota-fiscal.nr-nota-ant
           AND docum-est.cod-emitente = nota-fiscal.cod-emitente
           AND docum-est.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
    IF AVAIL docum-est THEN DO:
        FIND FIRST natur-oper
            WHERE natur-oper.nat-operacao = docum-est.nat-operacao NO-LOCK NO-ERROR.
        IF  AVAIL natur-oper
        AND natur-oper.nota-rateio  THEN
            NEXT.

        {cdp/cd4300.i4  "yes" docum-est.char-1}
        {rep/re1001a.i51 "yes"}
        
        FOR EACH bf-docum-est-nota 
           WHERE bf-docum-est-nota.cod-emitente              = docum-est.cod-emitente
             AND trim(substr(bf-docum-est-nota.char-1,1,16)) = c-embarque NO-LOCK:
            
            IF bf-docum-est-nota.idi-nf-simples-remes = 2 THEN DO:  /*nota filha*/
                FIND FIRST embarque-imp 
                     WHERE embarque-imp.embarque = c-embarque NO-LOCK NO-ERROR.
                IF AVAIL embarque-imp THEN DO:
                    ASSIGN c-embarque-pai = TRIM(SUBSTRING(embarque-imp.char-1,21,20)).
                    IF c-embarque-pai <> "" THEN DO: /*notas relacionadas*/
                        FOR FIRST bf-docum-est-mae 
                             WHERE bf-docum-est-mae.cod-emitente             = docum-est.cod-emitente
                              AND trim(substr(bf-docum-est-mae.char-1,1,16)) = c-embarque-pai NO-LOCK: /*embarque da nota, deve localizar embarque pai*/
                        END.
                        IF AVAIL bf-docum-est-mae THEN DO:
                            FIND FIRST bf-nota-fiscal
                                 WHERE bf-nota-fiscal.serie        = bf-docum-est-mae.serie-docto
                                   AND bf-nota-fiscal.nr-nota-fis  = bf-docum-est-mae.nro-docto
                                   AND bf-nota-fiscal.cod-emitente = bf-docum-est-mae.cod-emitente
                                   AND bf-nota-fiscal.nat-operacao = bf-docum-est-mae.nat-operacao  NO-LOCK NO-ERROR.
                
                            IF AVAIL bf-nota-fiscal THEN
                                ASSIGN c-observ-nota = c-observ-nota + "NF " + bf-nota-fiscal.nr-nota-fis + " " + string(bf-nota-fiscal.dt-emis-nota).
                        END.
                    END.
                    ELSE DO:
                        FOR FIRST bf-docum-est-mae 
                             WHERE bf-docum-est-mae.cod-emitente             = docum-est.cod-emitente
                              AND trim(substr(bf-docum-est-mae.char-1,1,16)) = c-embarque NO-LOCK: /*embarque da nota, deve localizar embarque pai*/
                        END.
                        IF AVAIL bf-docum-est-mae THEN DO:
                            FIND FIRST bf-nota-fiscal
                                 WHERE bf-nota-fiscal.serie        = bf-docum-est-mae.serie-docto
                                   AND bf-nota-fiscal.nr-nota-fis  = bf-docum-est-mae.nro-docto
                                   AND bf-nota-fiscal.cod-emitente = bf-docum-est-mae.cod-emitente
                                   AND bf-nota-fiscal.nat-operacao = bf-docum-est-mae.nat-operacao  NO-LOCK NO-ERROR.
                
                            IF AVAIL bf-nota-fiscal THEN
                                ASSIGN c-observ-nota = c-observ-nota + "NF " + bf-nota-fiscal.nr-nota-fis + " " + string(bf-nota-fiscal.dt-emis-nota).
                        END.
                        
                    END.
                END.
            END.
        END.
    END.
END.
