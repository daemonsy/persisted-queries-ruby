module FixturesHelpers
  def json_fixture(path_string)
    fixture = File.expand_path("../fixtures/#{path_string}.json", __dir__)

    JSON.parse(File.read(fixture))
  end
end
