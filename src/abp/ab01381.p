/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB01381 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab01381 MAB}
&ENDIF



PROCEDURE pi-fnDescMaterial:

    DEFINE INPUT PARAM cMaterial AS CHARACTER  NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM cRetorno AS CHARACTER  NO-UNDO.

    assign cRetorno = "".

    for first mab-tip-mater fields(des-tip-mater) 
        where mab-tip-mater.cod-tip-mater = cMaterial no-lock:
        assign cRetorno = mab-tip-mater.des-tip-mater.
    end.

END PROCEDURE.

PROCEDURE pi-fnDescSub:

    DEFINE INPUT PARAM cSub AS CHARACTER  NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM cRetorno AS CHARACTER  NO-UNDO.

    assign cRetorno = "".

    for first mab-sub-sist fields(des-sub-sist) 
        where mab-sub-sist.cod-sub-sist = cSub no-lock:
        assign cRetorno = mab-sub-sist.des-sub-sist.
    end.

END PROCEDURE.

PROCEDURE pi-fnDesLayout:

    DEFINE INPUT PARAM cLayout AS CHARACTER  NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM cRetorno AS CHARACTER  NO-UNDO.

    assign cRetorno = "".

    for first mpn-layout fields(des-layout)
        where mpn-layout.cod-layout = cLayout no-lock:
        assign cRetorno = mpn-layout.des-layout.
    end.

END PROCEDURE.

PROCEDURE pi-fnRetorno:

    DEFINE INPUT PARAM cCaract AS CHARACTER  NO-UNDO.
    DEFINE INPUT PARAM pTipo AS INTEGER  NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM cRetorno AS CHARACTER  NO-UNDO.


    for first mab-caract fields(cod-caract des-abrev des-caract)
      where mab-caract.cod-caract = cCaract no-lock.
      if pTipo = 1 then do:
        assign cRetorno = mab-caract.des-abrev.
      end.
      else do:
        assign cRetorno = mab-caract.des-caract.
      end.    
    end.

END PROCEDURE.

PROCEDURE pi-fnDescEvento:

    DEFINE INPUT PARAM cEvento AS CHARACTER  NO-UNDO.
    DEFINE INPUT-OUTPUT PARAM cRetorno AS CHARACTER  NO-UNDO.

    assign cRetorno = "".

    for first mab-event fields(des-evento) 
        where mab-event.cod-evento = cEvento no-lock:
        assign cRetorno = mab-event.des-evento.
    end.

END PROCEDURE.

procedure pi-fnDescComp:

    define input param cComp as char no-undo.
    define input param iTipo as int.
    define input-output param cRetorno as char no-undo.

    for first mab-comptmento fields(des-comptmento idi-oleo-filtro) 
    where mab-comptmento.cod-comptmento = cComp no-lock:
    if iTipo = 1 then
        assign cRetorno = mab-comptmento.des-comptmento.
    else DO:
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {frinc/i00fr003.i 04 mab-comptmento.idi-oleo-filtro}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  cRetorno = RETURN-VALUE.
        &else
            ASSIGN cRetorno = {frinc/i00fr003.i 04 mab-comptmento.idi-oleo-filtro}.
        &endif
    END.        
end.

end procedure.

procedure pi-fnDescConsumo:
    define input parameter pTipo as integer no-undo.
    define output parameter pDesc as char no-undo.

    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
    ASSIGN cAuxTraducao002 = {frinc/i01fr014.i 04 pTipo}.
    run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                        INPUT "",
                        INPUT "").
    ASSIGN  pDesc = RETURN-VALUE.
    &else
    ASSIGN pDesc = {frinc/i01fr014.i 04 pTipo}.
    &endif

end procedure.

procedure pi-fnDescPlano:
    define input parameter cPlano as char no-undo.
    define input parameter cod-model as char no-undo.
    define output parameter cRetorno as char no-undo.

    for first mmv-plano-prevent fields(des-plano-manut) 
        where mmv-plano-prevent.cod-plano = cPlano 
        and mmv-plano-prevent.cod-model = cod-model no-lock:
        assign cRetorno = mmv-plano-prevent.des-plano-manut.
    end.

end procedure.
