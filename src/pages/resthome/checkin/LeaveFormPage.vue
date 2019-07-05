<template>
  <normal-page>
    <el-form
      ref="form"
      :model="form" 
      label-width="120px"
      style="width: 600px;margin: 0 auto"
    >
      <el-form-item
        label="退住床位"
      >
        <span>{{berth.berthNo}}</span>
      </el-form-item>
      <el-form-item
        label="床位类型"
      >
        {{berthType.name}}；价格：{{berthType.monthPrice}}元/月
      </el-form-item>
      <el-form-item
        label="退住用户"
      >
        <span>{{berth.berthCheckin.userInfo.realName}}</span>
      </el-form-item>
      <el-form-item
        label="入住日期"
      >
        <el-date-picker
          v-model="checkin.startTime"
          type="date"
          value-format="yyyy-MM-dd"
          readonly
        />
      </el-form-item>
      <el-form-item
        prop="endTime"
        label="退住日期"
        :rules="[{required: true, message: ' '}]"
      >
        <el-date-picker
          v-model="form.endTime"
          type="date"
          value-format="yyyy-MM-dd"
          placeholder="选择日期"
        />
      </el-form-item>
      <el-form-item label="入住时长">
        <span>{{duration}}</span>
      </el-form-item>
      <el-form-item
        prop="amount"
        label="总费用"
        :rules="[{required: true, message: ' '}]"
      >
        <el-input-number v-model="form.amount" :precision="2" :controls="false"></el-input-number>
        <div class="info">
          <p>计算公式：</p>
          <code>
            <p><var>床位日价格</var> = <var>床位类型每月价格</var> / 30天</p>
            <p><var>总费用</var> = <var>床位日价格</var>×<var>入住时长天数</var> = <span>{{amount}}</span></p>
	        </code>
        </div>
      </el-form-item>
      <el-form-item label="押金">
        <span class="money">{{checkin.deposit}}</span>
      </el-form-item>
      <el-form-item
        prop="paidMoney"
        label="实交金额"
        :rules="[{required: true, message: ' '}]"
      >
        <el-input-number v-model="form.paidMoney" :precision="2" :min="0" :controls="false"></el-input-number>
      </el-form-item>
      <el-form-item label="欠款">
        <span class="money">{{debt.value}}</span>
        <div
          :style="{color: debt.color}"
        >{{debt.desc}}</div> 
        <span class="info">计算公式：<code><var>总费用</var> - <var>押金</var> - <var>实交金额</var></code></span>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="onSubmit" :loading="submitting" :disabled="disabled">确定</el-button>
      </el-form-item>
    </el-form>
  </normal-page>
</template>


<script>
import { toDurationText } from '@/utils/time-ui';

export default {
  pageProps: {
    title: '办理退住'
  },
  data() {
    return {
      disabled: false,
      submitting: false,
      form: {
        berthId: this.$params.berth.id,
        endTime: null,
        amount: null,
        paidMoney: null
      },
      amount: null,
      berth: this.$params.berth,
      berthType: {},
      checkin: {}
    };
  },
  computed: {
    duration() {
      return toDurationText(new Date(this.form.endTime).getTime() - new Date(this.checkin.startTime).getTime());
    },
    debt() {
      var value = (this.form.amount - this.form.paidMoney - this.checkin.deposit);
      let desc = '';
      let color = '';
      if(value > 0) {
        desc = '未交清';
        color = 'red';
      } else if(value == 0) {
        desc = '已交清';
        color = 'green';
      } else {
        desc = '已交清';
        desc += ', 需退款' + (-value).toFixed(2);
        color = '#FF5722';
      }
      value = value.toFixed(2);

      return {
        value,
        color,
        desc
      }
    }
  },
  watch: {
    'form.endTime': async function() {
      this.amount = '计算中...';
      const money = await this.axios.get(
        '/api/community/berth/checkin/calcPayMoney', {
          params: {
            checkinId: this.$params.berth.berthCheckin.id,
            endTime: this.form.endTime
          }
      });
      this.amount = money.toFixed(2);
      this.form.amount = this.amount;
    }
  },
  async mounted() {
    const ret = await this.axios.get('/api/community/berth/checkin/leaveForm', {params: {berthId: this.$params.berth.id}});
    this.berth = ret.berth;
    this.berthType = ret.berthType;
    this.checkin = ret.checkin;

    this.form.endTime = new Date();
  },
  methods: {
    async onSubmit() {
      this.$refs.form.validate(async (valid) => {
        if (!valid) return;
        this.submitting = true;
        const success = await this.axios.post('/api/community/berth/checkin/leave', this.form);
        this.submitting = false;
        if (success) {
          this.$message.success('退住成功');
          this.disabled = true;
          this.$params.onSuccess();
        } else {
          this.$message.error('未知错误');
        }
      });
    }
  }
}
</script>

<style scoped>
.money {
}
.info {
  color: #909399;
  font-size: 13px;
}
.info >>> p {
  line-height: 13px;
}
</style>
