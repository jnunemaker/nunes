module NunesHelper
  def compact_time_ago(time)
    if time.blank?
      tag.span "None", class: "text-muted"
    else
      distance_of_time_in_words(
        Time.now.utc,
        time,
        scope: "datetime.distance_in_words.compact_time_ago"
      ) + " ago"
    end
  end
end
