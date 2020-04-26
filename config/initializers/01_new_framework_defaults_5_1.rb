#
# Copyright (C) 2020 narra.eu
#
# This file is part of Narra Platform Core.
#
# Narra Platform Core is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Narra Platform Core is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Narra Platform Core. If not, see <http://www.gnu.org/licenses/>.
#
# Authors: Michal Mocnak <michal@narra.eu>, Eric Rosenzveig <eric@narra.eu>
#

# Be sure to restart your server when you modify this file.
#
# This file contains migration options to ease your Rails 5.1 upgrade.
#
# Once upgraded flip defaults one by one to migrate to the new default.
#
# Read the Guide for Upgrading Ruby on Rails for more info on each option.

# Make `form_with` generate non-remote forms.
Rails.application.config.action_view.form_with_generates_remote_forms = false

# Unknown asset fallback will return the path passed in when the given
# asset is not present in the asset pipeline.
# Rails.application.config.assets.unknown_asset_fallback = false
