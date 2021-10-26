# Copyright: (c) 2021, Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
# Copyright: (c) 2021, Narra Project
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

module Narra
  MODULES ||= Gem.loaded_specs.select { |_, spec|
    spec.metadata.key?("narra") && spec.metadata["narra"] == "module"
  }.values.collect { |m|
    {
      name: m.name,
      version: m.version.version,
      summary: m.summary,
      description: m.description,
      authors: m.authors,
      email: m.email,
      homepage: m.homepage,
      license: m.license
    }
  }
end
