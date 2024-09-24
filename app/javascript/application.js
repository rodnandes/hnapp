// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import {createApp} from 'https://unpkg.com/vue@3/dist/vue.esm-browser.js'

createApp(
  {
    data: () => ({
      stories: [],
      comments: {}
    }),

    created() {
      this.fetchStories();
    },

    methods: {
      async fetchStories() {
        this.stories = await (await fetch('api/stories.json')).json()
      },

      toggleComments(_event, storyId) {
        const story = this.findStory(storyId)
        story.commentsOpened = !story.commentsOpened
        story.commentToggleButtonText = story.commentsOpened ? '-Hide' : '+Show'
      },

      findStory(storyId) {
        return this.stories.find(story => story.hn_id === storyId)
      },

      userUrl(user) {
        return `https://news.ycombinator.com/user?id=${user}`
      },

      hasComments(storyId) {
        return this.findStory(storyId)?.comments?.length > 0
      },

      formatDate(date) {
        return new Date(date).toLocaleString('pt-BR', {
          year: 'numeric',
          month: '2-digit',
          day: '2-digit',
          hour: '2-digit',
          minute: '2-digit',
          hour12: false,
        })
      }

    }
  }
).mount('#vue-app')

