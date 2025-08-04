#!/usr/bin/env ruby

class Battery
  PMSET_BATTERY_STATUS = "pmset -g batt"

  STATUS_REGEX = {
    level: /(?<level>\d+%);/,
    source: /'(?<source>(AC\ Power)|(Battery))'/,
    state: /(?<state>(charging)|(discharging)|(finishing\ charge)|(charged));/,
    remaining: /(?<remaining>\d+:\d+)\ remaining/,
  }

  SOURCE_ICON = {
    "AC Power" => "🔌",
    "Battery" => "🔋"
  }

  CLOCK_ICON = "🕒"

  PLUGIN_ICON = "⚡️"

  def tmux_status
    return power if remaining == "0:00"

    power_and_remaining
  end

  private

  def power
    @power ||= "#{PLUGIN_ICON} #{state}  #{SOURCE_ICON[source]} #{level}"
  end

  def power_and_remaining
    @power_and_remaining ||= "#{power}  #{CLOCK_ICON} #{remaining}"
  end

  def status
    @status ||= `#{PMSET_BATTERY_STATUS}`.strip
  end

  def level
    @level ||= status.match(STATUS_REGEX[:level])[:level]
  end

  def source
    @source ||= status.match(STATUS_REGEX[:source])[:source]
  end

  def state
    @state ||= status.match(STATUS_REGEX[:state])[:state]
  end

  def remaining
    @remaining ||= status.match(STATUS_REGEX[:remaining])[:remaining]
  end
end

puts Battery.new.tmux_status

exit 0
