import java.util.Scanner;

public class Menu {
    private final Scanner scanner;
    private final IntegradorProlog integrador;

    public Menu(Scanner scanner, IntegradorProlog integrador) {
        this.scanner = scanner;
        this.integrador = integrador;
    }

    public void iniciar() {
        boolean ativo = true;

        while (ativo) {
            imprimirMenuPrincipal();
            String opcao = scanner.nextLine().trim();

            try {
                switch (opcao) {
                    case "1":
                        menuListarAlunos();
                        break;
                    case "2":
                        consultarAluno();
                        break;
                    case "3":
                        adicionarAluno();
                        break;
                    case "4":
                        menuAtualizarAluno();
                        break;
                    case "5":
                        removerAluno();
                        break;
                    case "6":
                        imprimir(integrador.mediaTurma());
                        break;
                    case "0":
                        ativo = false;
                        System.out.println("A sair...");
                        break;
                    default:
                        System.out.println("Opcao invalida.");
                        break;
                }
            } catch (NumberFormatException e) {
                System.out.println("Erro: introduza um valor numerico valido.");
            } catch (Exception e) {
                System.out.println("Erro: " + e.getMessage());
            }
        }
    }

    private void imprimirMenuPrincipal() {
        System.out.println();
        System.out.println("=== Sistema Prolog de Acompanhamento de Turmas ===");
        System.out.println("1 - Listar alunos");
        System.out.println("2 - Consultar aluno por ID");
        System.out.println("3 - Adicionar aluno");
        System.out.println("4 - Atualizar dados de aluno");
        System.out.println("5 - Remover aluno da base de conhecimento");
        System.out.println("6 - Mostrar media da turma");
        System.out.println("0 - Sair");
        System.out.print("Opcao: ");
    }

    private void menuListarAlunos() {
        boolean voltar = false;

        while (!voltar) {
            imprimirMenuListagens();
            String opcao = scanner.nextLine().trim();

            switch (opcao) {
                case "1":
                    imprimirLista("Alunos em risco", integrador.listarEmRisco());
                    break;
                case "2":
                    imprimirLista("Alunos participativos", integrador.listarParticipativos());
                    break;
                case "3":
                    imprimirLista("Alunos com bom desempenho", integrador.listarBons());
                    break;
                case "4":
                    imprimirLista("Alunos acima da media da turma", integrador.listarAcimaMedia());
                    break;
                case "5":
                    imprimirLista("Alunos em observacao", integrador.listarEmObservacao());
                    break;
                case "0":
                    voltar = true;
                    break;
                default:
                    System.out.println("Opcao invalida.");
                    break;
            }
        }
    }

    private void imprimirMenuListagens() {
        System.out.println();
        System.out.println("=== Listar alunos ===");
        System.out.println("1 - Alunos em risco");
        System.out.println("2 - Alunos participativos");
        System.out.println("3 - Alunos com bom desempenho");
        System.out.println("4 - Alunos acima da media da turma");
        System.out.println("5 - Bonus: alunos em observacao");
        System.out.println("0 - Voltar ao menu principal");
        System.out.print("Opcao: ");
    }

    private void menuAtualizarAluno() {
        boolean voltar = false;

        while (!voltar) {
            imprimirMenuAtualizacao();
            String opcao = scanner.nextLine().trim();

            try {
                switch (opcao) {
                    case "1":
                        atualizarMedia();
                        break;
                    case "2":
                        atualizarParticipacao();
                        break;
                    case "0":
                        voltar = true;
                        break;
                    default:
                        System.out.println("Opcao invalida.");
                        break;
                }
            } catch (NumberFormatException e) {
                System.out.println("Erro: introduza um valor numerico valido.");
            }
        }
    }

    private void imprimirMenuAtualizacao() {
        System.out.println();
        System.out.println("=== Atualizar dados de aluno ===");
        System.out.println("1 - Atualizar media");
        System.out.println("2 - Atualizar participacao no forum");
        System.out.println("0 - Voltar ao menu principal");
        System.out.print("Opcao: ");
    }

    private int lerId() {
        System.out.print("ID do aluno: ");
        String texto = scanner.nextLine().trim();
        return Integer.parseInt(texto);
    }

    private double lerDouble(String mensagem) {
        System.out.print(mensagem);
        String texto = scanner.nextLine().trim().replace(',', '.');
        return Double.parseDouble(texto);
    }

    private String lerTexto(String mensagem) {
        System.out.print(mensagem);
        return scanner.nextLine().trim();
    }

    private void consultarAluno() {
        int id = lerId();
        imprimir(integrador.consultarAluno(id));
    }

    private void adicionarAluno() {
        int id = lerId();
        String nome = lerTexto("Nome do aluno: ");

        if (integrador.adicionarAluno(id, nome)) {
            System.out.println("Aluno adicionado e base persistida.");
        } else {
            System.out.println("Nao foi possivel adicionar o aluno. Verifique se o ID ja existe.");
        }
    }

    private void atualizarMedia() {
        int id = lerId();
        double media = lerDouble("Nova media (0 a 20): ");

        if (integrador.atualizarMedia(id, media)) {
            System.out.println("Media atualizada e base persistida.");
        } else {
            System.out.println("Nao foi possivel atualizar a media.");
        }
    }

    private void atualizarParticipacao() {
        int id = lerId();
        int participacoes = Integer.parseInt(lerTexto("Numero de participacoes: "));

        if (integrador.atualizarParticipacao(id, participacoes)) {
            System.out.println("Participacao atualizada e base persistida.");
        } else {
            System.out.println("Nao foi possivel atualizar a participacao.");
        }
    }

    private void removerAluno() {
        int id = lerId();
        String confirmacao = lerTexto("Confirmar remocao? (s/N): ");

        if (!"s".equalsIgnoreCase(confirmacao)) {
            System.out.println("Operacao cancelada.");
            return;
        }

        if (integrador.removerAluno(id)) {
            System.out.println("Aluno removido e base persistida.");
        } else {
            System.out.println("Aluno nao encontrado.");
        }
    }

    private void imprimir(String texto) {
        System.out.println();
        System.out.println(texto);
    }

    private void imprimirLista(String titulo, String lista) {
        System.out.println();
        System.out.println(titulo + ":");
        System.out.println();
        System.out.println(lista);
    }
}
