
var app = new Vue({
  el: '#app',
    methods: {
      pick_note: function(event) {
          this.cur_note = event.target.innerText;
          this.pick();
      },
        pick_scale: function (event) {
          this.cur_scale = event.target.innerText;
            this.pick();
        },
        pick_tuning: function (event) {
          this.cur_tuning = event.target.innerText;
            this.pick();
        },

        pick: function() {
          fetch('/pick', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json'
              },
              body: JSON.stringify({
                note: this.cur_note,
                  scale: this.cur_scale,
                  tuning: this.cur_tuning,
              })
            })
        }

    },
  data: {
    message: 'Привет, Vue!',
    tunings: {{tunings}},
    scales: {{scales}},
    notes: {{notes}},
    cur_note: "{{cur_note}}",
    cur_tuning: "{{cur_tuning}}",
    cur_scale: "{{cur_scale}}",

  }
})