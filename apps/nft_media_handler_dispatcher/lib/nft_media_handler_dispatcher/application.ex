defmodule NFTMediaHandlerDispatcher.Application do
  use Application

  @impl Application
  def start(_type, _args) do
    children = [
      # for backfiller
      # Supervisor.child_spec({Task.Supervisor, name: NFTMediaHandlerDispatcher.TaskSupervisor},
      #   id: NFTMediaHandlerDispatcher.TaskSupervisor
      # ),
      NFTMediaHandlerDispatcher.Queue,
      NFTMediaHandlerDispatcher.Backfiller
    ]

    opts = [strategy: :one_for_one, name: NFTMediaHandlerDispatcher.Supervisor, max_restarts: 1_000]

    if Application.get_env(:nft_media_handler, :standalone_media_worker?) do
      Supervisor.start_link([], opts)
    else
      Supervisor.start_link(children, opts)
    end
  end
end
