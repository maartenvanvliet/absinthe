defmodule Absinthe.Type.DeprecationTest do
  use Absinthe.Case, async: true

  alias Absinthe.Type

  defmodule TestSchema do
    use Absinthe.Schema

    query do
      # Query type must exist
    end

    object :profile do
      description "A profile"

      field :name, :string

      field :profile_picture,
        type: :string,
        args: [
          width: [type: :integer],
          height: [type: :integer],
          size: [type: :string, deprecate: "Not explicit enough"],
          source: [type: :string, deprecate: true]
        ]

      field :email_address, :string do
        deprecate "privacy"
      end

      field :address, :string, deprecate: true
    end

    enum :colors do
      value :red, deprecate: true
      value :blue, deprecate: "This isn't supported"
    end

    input_object :contact_input do
      field :email, non_null(:string), deprecate: true
      field :name, non_null(:string), deprecate: "This isn't supported"
    end
  end

  describe "fields" do
    test "can be deprecated" do
      obj = TestSchema.__absinthe_type__(:profile)
      assert Type.deprecated?(obj.fields.email_address)
      assert "privacy" == obj.fields.email_address.deprecation.reason
      assert Type.deprecated?(obj.fields.address)
      assert nil == obj.fields.address.deprecation.reason
    end
  end

  describe "arguments" do
    test "can be deprecated" do
      field = TestSchema.__absinthe_type__(:profile).fields.profile_picture
      assert Type.deprecated?(field.args.size)
      assert "Not explicit enough" == field.args.size.deprecation.reason
      assert Type.deprecated?(field.args.source)
      assert nil == field.args.source.deprecation.reason
    end
  end

  describe "enum values" do
    test "can be deprecated" do
      enum_values = TestSchema.__absinthe_type__(:colors).values
      assert Type.deprecated?(enum_values.blue)
      assert "This isn't supported" == enum_values.blue.deprecation.reason
      assert Type.deprecated?(enum_values.red)
      assert nil == enum_values.red.deprecation.reason
    end
  end

  describe "input fields values" do
    test "can be deprecated" do
      input = TestSchema.__absinthe_type__(:contact_input)
      assert Type.deprecated?(input.fields.name)
      assert "This isn't supported" == input.fields.name.deprecation.reason
      assert Type.deprecated?(input.fields.email)
      assert nil == input.fields.email.deprecation.reason
    end
  end
end
