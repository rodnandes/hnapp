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

      async fetchStoryComments(storyId) {
        if(this.comments[storyId]) return;

        this.comments[storyId] = await (await fetch(`api/stories/${storyId}/comments.json`)).json()
      },

      toggleComments(_event, storyId) {
        const story = this.findStory(storyId)
        story.commentsOpened = !story.commentsOpened
        story.commentToggleButtonText = story.commentsOpened ? '-Hide' : '+Show'

        if (story.commentsOpened) {
          this.fetchStoryComments(storyId)
        }
      },

      findStory(storyId) {
        return this.stories.find(story => story.hn_id === storyId)
      },

      userUrl(user) {
        return `https://news.ycombinator.com/user?id=${user}`
      },

      hasComments(storyId) {
        this.fetchStoryComments(storyId)

        return this.comments[storyId]?.length > 0
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

