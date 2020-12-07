# SPDX-License-Identifier: AGPL-3.0-only
defmodule Bonfire.GraphQL.FetchFields do
  @enforce_keys [:queries, :query, :group_fn]
  defstruct [
    :queries,
    :query,
    :group_fn,
    map_fn: nil,
    filters: []
  ]

  @repo Application.get_env(:bonfire_api_graphql, :repo_module)

  alias Bonfire.GraphQL.{Fields, FetchFields}

  @type t :: %FetchFields{
          queries: atom,
          query: atom,
          group_fn: (term -> term),
          map_fn: (term -> term) | nil,
          filters: list
        }

  def run(%FetchFields{
        queries: queries,
        query: query,
        group_fn: group_fn,
        map_fn: map_fn,
        filters: filters
      }) do
    apply(queries, :query, [query, filters])
    |> @repo.all()
    |> Fields.new(group_fn, map_fn)
  end
end
