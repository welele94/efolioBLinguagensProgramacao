import java.util.Map;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;
import org.jpl7.Variable;

public class IntegradorProlog {
    private final String ficheiroBase;

    public IntegradorProlog(String ficheiroBase) {
        this.ficheiroBase = ficheiroBase;
        carregarBase();
    }

    private void carregarBase() {
        Query consulta = new Query("consult", new Term[] { new Atom(ficheiroBase) });
        if (!consulta.hasSolution()) {
            throw new IllegalStateException("Nao foi possivel carregar " + ficheiroBase);
        }

        Query configurarPersistencia = new Query(
            "set_ficheiro_base",
            new Term[] { new Atom(ficheiroBase) }
        );
        if (!configurarPersistencia.hasSolution()) {
            throw new IllegalStateException("Nao foi possivel configurar a persistencia Prolog.");
        }
    }

    public String listarEmRisco() {
        return listarAlunosFormatado("listar_em_risco");
    }

    public String listarParticipativos() {
        return listarAlunosFormatado("listar_participativos");
    }

    public String listarBons() {
        return listarAlunosFormatado("listar_bons");
    }

    public String listarAcimaMedia() {
        return listarAlunosFormatado("listar_acima_media");
    }

    public String listarEmObservacao() {
        return listarAlunosFormatado("listar_em_observacao");
    }

    public String mediaTurma() {
        Variable media = new Variable("Media");
        Query consulta = new Query("media_turma", new Term[] { media });
        Map<String, Term> solucao = consulta.oneSolution();
        if (solucao == null) {
            return "Nao existem medias registadas.";
        }
        return "Media da turma: " + solucao.get("Media");
    }

    public String consultarAluno(int id) {
        Map<String, Term> solucao = obterDadosAluno(id);
        if (solucao == null) {
            return "Aluno nao encontrado.";
        }

        return formatarAluno(id, solucao);
    }

    public boolean adicionarAluno(int id, String nome) {
        return executarComando(
            "adicionar_aluno",
            new Term[] { new org.jpl7.Integer(id), new Atom(nome) }
        );
    }

    public boolean atualizarMedia(int id, double media) {
        return executarComando(
            "atualizar_media",
            new Term[] { new org.jpl7.Integer(id), new org.jpl7.Float(media) }
        );
    }

    public boolean atualizarParticipacao(int id, int participacoes) {
        return executarComando(
            "atualizar_participacao",
            new Term[] { new org.jpl7.Integer(id), new org.jpl7.Integer(participacoes) }
        );
    }

    public boolean removerAluno(int id) {
        return executarComando("remover_aluno", new Term[] { new org.jpl7.Integer(id) });
    }

    private String listarAlunosFormatado(String predicadoListagem) {
        Variable lista = new Variable("Lista");
        Query consulta = new Query(predicadoListagem, new Term[] { lista });
        Map<String, Term> solucao = consulta.oneSolution();

        if (solucao == null) {
            return "Sem resultados.";
        }

        Term[] ids = solucao.get("Lista").toTermArray();
        if (ids.length == 0) {
            return "Sem resultados.";
        }

        StringBuilder resultado = new StringBuilder();

        for (Term idTermo : ids) {
            int id = idTermo.intValue();
            Map<String, Term> dados = obterDadosAluno(id);

            if (dados != null) {
                resultado.append(formatarAluno(id, dados))
                    .append(System.lineSeparator());
            }
        }

        return resultado.toString();
    }

    private Map<String, Term> obterDadosAluno(int id) {
        Variable nome = new Variable("Nome");
        Variable participacoes = new Variable("Participacoes");
        Variable media = new Variable("Media");
        Variable estado = new Variable("Estado");

        Query consulta = new Query(
            "dados_aluno",
            new Term[] {
                new org.jpl7.Integer(id),
                nome,
                participacoes,
                media,
                estado
            }
        );

        return consulta.oneSolution();
    }

    private String formatarAluno(int id, Map<String, Term> dados) {
        return "- Aluno ID: " + id + System.lineSeparator()
            + "  Nome: " + limparAtom(dados.get("Nome")) + System.lineSeparator()
            + "  Participacoes: " + dados.get("Participacoes") + System.lineSeparator()
            + "  Media: " + dados.get("Media") + System.lineSeparator()
            + "  Estado: " + dados.get("Estado") + System.lineSeparator();
    }

    private boolean executarComando(String predicado, Term[] argumentos) {
        Query consulta = new Query(predicado, argumentos);
        return consulta.hasSolution();
    }

    private String limparAtom(Term termo) {
        String texto = termo.toString();
        if (texto.length() >= 2 && texto.startsWith("'") && texto.endsWith("'")) {
            return texto.substring(1, texto.length() - 1);
        }
        return texto;
    }
}
