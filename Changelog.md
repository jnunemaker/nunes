# master

* no longer doing underscore on active job class name when instrumenting it (ie: active_job.spam_detector_job.perform changed to active_job.SpamDetectorJob.perform)
* drop ruby 1.9 support

# 0.4.0

## Backwards Compatibility Break

* Changed required Rails version to 4.2.

# 0.3.0

## Backwards Compatibility Break

* Cleaning action view template and partial paths before sending to adapter. Prior to this change, action view metrics looked like: action_view.template.app.views.posts.post.html.erb. They now look like: action_view.template.app_views_posts_post_html_erb. The reason is that "." is typically a namespace in most metric services, which means really deep nesting of metrics, especially for views rendered from engines in gems. This keeps shallows up the nesting. Thanks to @dewski for reporting.

# 0.2.0

## Backwards Compatibility Break

* No longer using the inflector to pretty up metric names. This means that when you upgrade from 0.1 and 0.2 some metrics will change names.
* Namespaced several of the stats to make them easier to graph.

## Fixed

* Instrumenting namespaced controllers

# 0.1.0

* Initial release.
