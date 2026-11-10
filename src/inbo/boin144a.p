/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN144A 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOIN144A MUT}
&ENDIF

{inbo/boin144a.i}
{database/tgin/tdp/tdin144.i}   /* pi-valida-eliminacao-grup-maquina */

PROCEDURE GerarGrupoMaquina:

   define input  parameter table for tt-grp-maq-sfc.
   define output parameter table for tt-erro.

   for each tt-grp-maq-sfc:

      find grup-maquina where
           grup-maquina.gm-codigo = tt-grp-maq-sfc.gm-codigo EXCLUSIVE-LOCK no-error.

      if tt-grp-maq-sfc.log-eliminado then do:
         if not available grup-maquina then next.
         run pi-valida-eliminacao-grup-maquina.
         if return-value <> "OK":U then
              run pi-gera-erros.
         else delete grup-maquina.
         next.
      end.

      if not available grup-maquina then do:
         create grup-maquina.
         assign grup-maquina.gm-codigo = tt-grp-maq-sfc.gm-codigo
                grup-maquina.descricao = tt-grp-maq-sfc.descricao.
      end.    
      else
         assign grup-maquina.descricao = tt-grp-maq-sfc.descricao.
   end.                          

END PROCEDURE.

PROCEDURE pi-gera-erros:

    {database/tgin/tdp/tdin144.i1}

    for each tt-erro:
        if index(tt-erro.mensagem,":") = 0 then
           assign tt-erro.mensagem = grup-maquina.gm-codigo + ": " + tt-erro.mensagem.
    end.

END PROCEDURE.
