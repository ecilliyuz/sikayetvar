<template>
  <div class="home">
    <h2>Şikayet Var</h2>
    <textarea rows="4" cols="50" @input="onInputChange" v-model="search"> </textarea>
    <p><span v-html="rawHtml"></span></p>
    <ul>
      <li v-if="blackListed.length">BlackListed: {{ blackListed }}</li>
      <li v-if="grayListed.length">grayListed: {{ grayListed }}</li>
      <li v-if="undefinedList.length">undefinedList: {{ undefinedList }}</li>
    </ul>

    <p v-if="errLog">
      error: <span style="color: red">{{ errLog }}</span>
    </p>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  data() {
    return {
      search: '',
      rawHtml: '',
      blackListed: [],
      grayListed: [],
      undefinedList: [],
      errLog: '',
    };
  },

  watch: {
    search(newValue) {
      if (!newValue) {
        this.rawHtml = newValue;
        this.blackListed = [];
        this.grayListed = [];
        this.undefinedList = [];
      }
      if (!this.search.length) {
        return;
      }

      axios.post('https://api.sikayetvar.com/dictionary/phrase/check', this.search).then(
        (res) => {
          console.log(res.data);
          let stringArray = this.search.split(' ');
          this.blackListed = res.data.blackListed;
          this.grayListed = res.data.grayListed;
          this.undefinedList = res.data.undefined;
          stringArray.forEach((element, index) => {
            if (this.blackListed.find((a) => a == element)) {
              stringArray[index] = "<span style='color: red'><del>" + element + '</del></span>';
            } else if (this.grayListed.find((a) => a == element)) {
              stringArray[index] = '<a>' + element + '</a>';
            } else if (this.undefinedList.find((a) => a == element)) {
              stringArray[index] = "<u class='greyUnderline'>" + element + '</u>';
            }
          });

          this.rawHtml = stringArray.toString().replaceAll(',', ' ');
        },
        (err) => {
          console.log(err);
          this.errLog = err;
        }
      );
    },
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  margin-top: 5%;
}

.greyUnderline {
  text-decoration: underline;
  -webkit-text-decoration-color: grey; /* safari still uses vendor prefix */
  text-decoration-color: grey;
}

a::after {
  display: block;
  content: '3';
  width: 100%;
  height: 1px;
  background: black;
  position: absolute;
  bottom: 0;
  left: 0;
}

a {
  position: relative;
}
</style>
