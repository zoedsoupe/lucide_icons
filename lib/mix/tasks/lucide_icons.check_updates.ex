defmodule Mix.Tasks.LucideIcons.CheckUpdates do
  @moduledoc """
  Checks if there's a new version of lucide-static available.

  This is a simple task primarily used by CI to check for updates.

  ## Usage

      mix lucide_icons.check_updates

  Returns exit code 0 if an update is available, 1 if already up-to-date.
  """
  use Mix.Task

  @shortdoc "Checks for lucide-static updates"

  def run(_args) do
    Application.ensure_all_started(:req)

    case check_for_updates() do
      {:ok, :up_to_date, current} ->
        Mix.shell().info("Current version: v#{current}")
        Mix.shell().info("Already up-to-date with lucide-static")
        exit({:shutdown, 1})

      {:ok, :update_available, current, latest} ->
        Mix.shell().info("Current version: v#{current}")
        Mix.shell().info("Latest version: v#{latest}")
        Mix.shell().info("Update available!")
        exit({:shutdown, 0})

      {:error, reason} ->
        Mix.shell().error("Error: #{reason}")
        exit({:shutdown, 2})
    end
  end

  defp check_for_updates do
    with {:ok, current} <- get_current_version(),
         {:ok, latest} <- fetch_latest_version() do
      if Version.compare(current, latest) == :lt do
        {:ok, :update_available, current, latest}
      else
        {:ok, :up_to_date, current}
      end
    end
  end

  defp get_current_version do
    package_lock_path = Path.join(["priv", "package-lock.json"])

    with {:ok, content} <- File.read(package_lock_path),
         {:ok, json} <- JSON.decode(content),
         version when is_binary(version) <-
           get_in(json, ["packages", "node_modules/lucide-static", "version"]) do
      {:ok, version}
    else
      _ -> {:error, "Could not read current version from package-lock.json"}
    end
  end

  defp fetch_latest_version do
    url = "https://registry.npmjs.org/lucide-static/latest"

    case Req.get(url) do
      {:ok, %{status: 200, body: body}} ->
        case body do
          %{"version" => version} -> {:ok, version}
          _ -> {:error, "Could not parse npm registry response"}
        end

      {:ok, %{status: status}} ->
        {:error, "npm registry returned status #{status}"}

      {:error, reason} ->
        {:error, "Could not fetch latest version from npm: #{inspect(reason)}"}
    end
  end
end
