defmodule Naboo.AssetStore do
  @moduledoc """
  Responsible for accepting files and uploading them to an asset store.
  """

  alias ExAws.S3

  @doc """
  Accepts a base64 encoded image and uploads it to S3.

  ## Examples

      iex> upload_image(...)
      "https://image_bucket.s3.amazonaws.com/dbaaee81609747ba82bea2453cc33b83.png"

  """
  @spec upload_image(String.t) :: s3_url :: String.t
  def upload_image(image_base64) do
    bucket = "naboo-data"

    # Decode the image
    {:ok, image_binary} = Base.decode64(image_base64)

    # Generate a unique filename
    filename =
      image_binary
      |> image_extension()
      |> unique_filename()

    # Upload to S3
    {:ok, response} =
      S3.put_object(bucket, filename, image_binary)
      |> ExAws.request()

    # Generate the full URL to the newly uploaded image
#    {:ok, "https://#{bucket}.s3.amazonaws.com/#{filename}"}
    {:ok, "d2l71q8oyqn1bg.cloudfront.net/#{filename}"}
  end

  # Generates a unique filename with a given extension
  defp unique_filename(extension) do
    UUID.uuid4(:hex) <> extension
  end

  # Helper functions to read the binary to determine the image extension
  defp image_extension(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>), do: ".png"
  defp image_extension(<<0xff, 0xD8, _::binary>>), do: ".jpg"
end